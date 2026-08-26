import '../../explore/data/explore_mock_data.dart';
import '../../explore/models/explore_item.dart';

ExploreItem _findExploreItem(String id) {
  return exploreMockItems.firstWhere((item) => item.id == id);
}

final Map<String, List<ExploreItem>> savedPlaceMockData = {
  '1': [_findExploreItem('1'), _findExploreItem('2'), _findExploreItem('3')],
  '2': [
    _findExploreItem('4'),
    _findExploreItem('5'),
    _findExploreItem('6'),
    _findExploreItem('7'),
    _findExploreItem('8'),
  ],
  '3': [_findExploreItem('1'), _findExploreItem('3')],
  '4': [_findExploreItem('2')],
  '5': [],
};
