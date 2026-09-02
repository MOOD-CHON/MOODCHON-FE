import 'package:flutter/material.dart';

import '../../models/accommodation_recommendation.dart';
import 'lodging_card.dart';

class LodgingCarousel extends StatefulWidget {
  const LodgingCarousel({
    super.key,
    required this.items,
    required this.onPageChanged,
    required this.onDetailTap,
  });

  final List<AccommodationRecommendation> items;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<AccommodationRecommendation> onDetailTap;

  @override
  State<LodgingCarousel> createState() => _LodgingCarouselState();
}

class _LodgingCarouselState extends State<LodgingCarousel> {
  static const double _cardWidth = 320;
  static const double _baseImageHeight = 174;

  static const double _horizontalPadding = 16;
  static const double _gap = 10;

  static const double _inactiveScale = 0.95;

  // RenderFlex 소수점 오차 방지
  static const double _viewportSafety = 4;

  // 이 정도 이상 움직이면 다음/이전 카드로 넘김
  static const double _dragThreshold = 35;

  final ScrollController _scrollController = ScrollController();

  late List<GlobalKey> _measureKeys;
  late List<double> _imageHeights;

  double? _commonCardHeight;

  int _currentIndex = 0;
  bool _hasMeasured = false;
  bool _isSnapping = false;

  double _dragStartOffset = 0;

  @override
  void initState() {
    super.initState();

    _initializeMeasurement();
    _scheduleMeasurement();
  }

  @override
  void didUpdateWidget(covariant LodgingCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_sameItems(oldWidget.items, widget.items)) {
      _initializeMeasurement();
      _scheduleMeasurement();
    }
  }

  bool _sameItems(
    List<AccommodationRecommendation> oldItems,
    List<AccommodationRecommendation> newItems,
  ) {
    if (oldItems.length != newItems.length) {
      return false;
    }

    for (int i = 0; i < oldItems.length; i++) {
      if (oldItems[i].id != newItems[i].id) {
        return false;
      }
    }

    return true;
  }

  void _initializeMeasurement() {
    _measureKeys = List.generate(widget.items.length, (_) => GlobalKey());

    _imageHeights = List.filled(widget.items.length, _baseImageHeight);

    _commonCardHeight = null;
    _hasMeasured = false;

    if (_currentIndex >= widget.items.length) {
      _currentIndex = 0;
    }
  }

  void _scheduleMeasurement() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _measureCards();
    });
  }

  void _measureCards() {
    if (_hasMeasured || widget.items.isEmpty) {
      return;
    }

    final List<double> heights = [];

    for (final key in _measureKeys) {
      final BuildContext? cardContext = key.currentContext;

      if (cardContext == null) {
        return;
      }

      final RenderObject? renderObject = cardContext.findRenderObject();

      if (renderObject is! RenderBox || !renderObject.hasSize) {
        return;
      }

      heights.add(renderObject.size.height);
    }

    if (heights.length != widget.items.length) {
      return;
    }

    final double maxHeight = heights.reduce((a, b) => a > b ? a : b);

    final List<double> nextImageHeights = List.generate(heights.length, (
      index,
    ) {
      final double missingHeight = maxHeight - heights[index];

      return _baseImageHeight + missingHeight;
    });

    setState(() {
      _commonCardHeight = maxHeight;
      _imageHeights = nextImageHeights;
      _hasMeasured = true;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    if (_isSnapping || !_scrollController.hasClients) {
      return;
    }

    _dragStartOffset = _scrollController.offset;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (_isSnapping || !_scrollController.hasClients) {
      return;
    }

    /*
     * 손가락을 왼쪽으로 이동
     * details.delta.dx < 0
     * → scroll offset 증가
     *
     * 손가락을 오른쪽으로 이동
     * details.delta.dx > 0
     * → scroll offset 감소
     */

    final double nextOffset = _scrollController.offset - details.delta.dx;

    final double clampedOffset = nextOffset
        .clamp(
          _scrollController.position.minScrollExtent,
          _scrollController.position.maxScrollExtent,
        )
        .toDouble();

    _scrollController.jumpTo(clampedOffset);
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_isSnapping || !_scrollController.hasClients) {
      return;
    }

    final double movedDistance = _scrollController.offset - _dragStartOffset;

    int targetIndex = _currentIndex;

    if (movedDistance > _dragThreshold) {
      // 스크롤 offset 증가
      // → 다음 순위
      targetIndex = _currentIndex + 1;
    } else if (movedDistance < -_dragThreshold) {
      // 스크롤 offset 감소
      // → 이전 순위
      targetIndex = _currentIndex - 1;
    }

    targetIndex = targetIndex.clamp(0, widget.items.length - 1).toInt();

    _snapToIndex(targetIndex);
  }

  Future<void> _snapToIndex(int index) async {
    if (_isSnapping || !_scrollController.hasClients) {
      return;
    }

    _isSnapping = true;

    final double targetOffset = _targetOffsetForIndex(index);

    await _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOutCubic,
    );

    if (!mounted) {
      return;
    }

    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });

      widget.onPageChanged(index);
    }

    _isSnapping = false;
  }

  double _targetOffsetForIndex(int index) {
    final ScrollPosition position = _scrollController.position;

    if (index == 0) {
      // 1위:
      // 왼쪽 패딩 16 유지
      return position.minScrollExtent;
    }

    if (index == widget.items.length - 1) {
      // 마지막:
      // 오른쪽 패딩 16 유지
      return position.maxScrollExtent;
    }

    // 2~4위:
    // 해당 카드의 중앙을
    // viewport 중앙에 정확하게 위치
    final double cardCenter =
        _horizontalPadding + (index * (_cardWidth + _gap)) + (_cardWidth / 2);

    final double target = cardCenter - (position.viewportDimension / 2);

    return target
        .clamp(position.minScrollExtent, position.maxScrollExtent)
        .toDouble();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const SizedBox.shrink();
    }

    if (!_hasMeasured || _commonCardHeight == null) {
      return _buildMeasurementLayer();
    }

    return SizedBox(
      height: _commonCardHeight! + 20 + _viewportSafety,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragStart: _onHorizontalDragStart,
          onHorizontalDragUpdate: _onHorizontalDragUpdate,
          onHorizontalDragEnd: _onHorizontalDragEnd,
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,

            // 카드 그림자가 캐러셀 경계에서 잘리지 않도록
            clipBehavior: Clip.none,

            physics: const NeverScrollableScrollPhysics(),

            padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),

            itemCount: widget.items.length,

            separatorBuilder: (_, __) {
              return const SizedBox(width: _gap);
            },

            itemBuilder: (context, index) {
              final bool isSelected = index == _currentIndex;

              return Center(
                child: AnimatedScale(
                  scale: isSelected ? 1 : _inactiveScale,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeOut,
                  alignment: Alignment.center,
                  child: LodgingCard(
                    data: widget.items[index],
                    imageHeight: _imageHeights[index],
                    onDetailTap: () {
                      widget.onDetailTap(widget.items[index]);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMeasurementLayer() {
    return Offstage(
      offstage: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(widget.items.length, (index) {
          return KeyedSubtree(
            key: _measureKeys[index],
            child: LodgingCard(
              data: widget.items[index],
              imageHeight: _baseImageHeight,
              onDetailTap: () {},
            ),
          );
        }),
      ),
    );
  }
}
