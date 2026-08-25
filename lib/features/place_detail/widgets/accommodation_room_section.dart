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
  late final PageController _pageController;

  int _currentIndex = 0;
  double _maxCardHeight = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(viewportFraction: 200 / 328);
  }

  @override
  void dispose() {
    _pageController.dispose();
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

  @override
  Widget build(BuildContext context) {
    if (widget.rooms.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 카드들의 자연 높이를 먼저 측정한다.
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
            width: 328,
            height: _maxCardHeight,
            child: PageView.builder(
              controller: _pageController,
              padEnds: false,
              itemCount: widget.rooms.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 11),
                  child: SizedBox(
                    width: 189,
                    height: _maxCardHeight,
                    child: AccommodationRoomCard(
                      room: widget.rooms[index],
                      expandHeight: true,
                    ),
                  ),
                );
              },
            ),
          ),

        if (_maxCardHeight > 0) ...[
          const SizedBox(height: 11),

          SizedBox(
            width: 328,
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
