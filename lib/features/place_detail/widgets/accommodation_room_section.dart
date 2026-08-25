import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../models/room_info.dart';
import 'accommodation_room_card.dart';

class AccommodationRoomSection extends StatefulWidget {
  const AccommodationRoomSection({super.key, required this.rooms});

  final List<RoomInfo> rooms;

  @override
  State<AccommodationRoomSection> createState() =>
      _AccommodationRoomSectionState();
}

class _AccommodationRoomSectionState extends State<AccommodationRoomSection> {
  static const double _contentWidth = 328;
  static const double _cardWidth = 189;
  static const double _cardGap = 11;

  final ScrollController _scrollController = ScrollController();

  int _currentIndex = 0;
  double _maxCardHeight = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _updateMaxCardHeight(double height) {
    if (height <= _maxCardHeight) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || height <= _maxCardHeight) {
        return;
      }

      setState(() {
        _maxCardHeight = height;
      });
    });
  }

  void _updateCurrentIndex() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 1) {
      final lastIndex = widget.rooms.length - 1;

      if (_currentIndex != lastIndex) {
        setState(() {
          _currentIndex = lastIndex;
        });
      }

      return;
    }

    const cardExtent = _cardWidth + _cardGap;

    final index = (_scrollController.offset / cardExtent).round().clamp(
      0,
      widget.rooms.length - 1,
    );

    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.rooms.isEmpty) {
      return const SizedBox.shrink();
    }

    final screenWidth = MediaQuery.sizeOf(context).width;

    // 393 기준 약 32.5
    final sideMargin = (screenWidth - _contentWidth) / 2;

    // 328px 콘텐츠 시작점부터 화면 오른쪽 끝까지
    final carouselWidth = screenWidth - sideMargin;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 객실 카드들의 자연 높이를 먼저 측정
        Offstage(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.rooms
                .map(
                  (room) => _MeasureHeight(
                    onHeightChanged: _updateMaxCardHeight,
                    child: AccommodationRoomCard(room: room),
                  ),
                )
                .toList(),
          ),
        ),

        if (_maxCardHeight > 0)
          SizedBox(
            width: _contentWidth,

            // 카드 아래 그림자 여유만 확보
            height: _maxCardHeight + 16,

            child: OverflowBox(
              alignment: Alignment.topLeft,

              // 가로 방향만 화면 오른쪽까지 확장
              minWidth: carouselWidth,
              maxWidth: carouselWidth,

              minHeight: _maxCardHeight + 16,
              maxHeight: _maxCardHeight + 16,

              child: SizedBox(
                width: carouselWidth,
                height: _maxCardHeight + 16,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollUpdateNotification ||
                        notification is ScrollEndNotification) {
                      _updateCurrentIndex();
                    }

                    return false;
                  },
                  child: ListView.separated(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    physics: const BouncingScrollPhysics(),

                    // 위쪽 패딩 없음
                    // 카드 아래 그림자 여유만 16
                    padding: EdgeInsets.only(right: sideMargin, bottom: 16),

                    itemCount: widget.rooms.length,

                    separatorBuilder: (_, __) =>
                        const SizedBox(width: _cardGap),

                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: _cardWidth,
                        height: _maxCardHeight,
                        child: AccommodationRoomCard(
                          room: widget.rooms[index],
                          expandHeight: true,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

        if (_maxCardHeight > 0) ...[
          const SizedBox(height: 11),

          SizedBox(
            width: _contentWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.rooms.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(
                    right: index == widget.rooms.length - 1 ? 0 : 2,
                  ),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == _currentIndex
                          ? AppColors.main
                          : const Color(0xFFD9D9D9),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ],
    );
  }
}

class _MeasureHeight extends StatefulWidget {
  const _MeasureHeight({required this.onHeightChanged, required this.child});

  final ValueChanged<double> onHeightChanged;
  final Widget child;

  @override
  State<_MeasureHeight> createState() => _MeasureHeightState();
}

class _MeasureHeightState extends State<_MeasureHeight> {
  double? _previousHeight;

  void _measureHeight() {
    final renderObject = context.findRenderObject();

    if (renderObject is! RenderBox || !renderObject.hasSize) {
      return;
    }

    final height = renderObject.size.height;

    if (_previousHeight == height) {
      return;
    }

    _previousHeight = height;
    widget.onHeightChanged(height);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _measureHeight();
      }
    });

    return widget.child;
  }
}
