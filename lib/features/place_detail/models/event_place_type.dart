import '../../../core/widgets/tag/map_tag.dart';

enum EventPlaceType { event, performance, festival }

extension EventPlaceTypeX on EventPlaceType {
  String get label {
    switch (this) {
      case EventPlaceType.event:
        return '행사';
      case EventPlaceType.performance:
        return '공연';
      case EventPlaceType.festival:
        return '축제';
    }
  }

  MapTagColor get mapTagColor {
    switch (this) {
      case EventPlaceType.event:
      case EventPlaceType.performance:
      case EventPlaceType.festival:
        return MapTagColor.red;
    }
  }
}
