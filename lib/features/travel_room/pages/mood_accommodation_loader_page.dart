import 'package:flutter/material.dart';

import '../data/travel_room_api.dart';
import '../models/chonkang_trip_info.dart';
import '../models/mood_accommodation_page_data.dart';
import '../models/mood_result_detail.dart';
import '../models/trip_info_labels.dart';
import 'mood_accommodation_page.dart';

const int _topAccommodationCount = 5;
const int _moodTagCount = 4;

class MoodAccommodationLoaderPage extends StatefulWidget {
  const MoodAccommodationLoaderPage({super.key, required this.chonkangId});

  final int chonkangId;

  @override
  State<MoodAccommodationLoaderPage> createState() => _MoodAccommodationLoaderPageState();
}

class _MoodAccommodationLoaderPageState extends State<MoodAccommodationLoaderPage> {
  late Future<MoodAccommodationPageData> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _fetch();
  }

  Future<MoodAccommodationPageData> _fetch() async {
    final detailFuture = TravelRoomApi.instance.fetchMoodResultDetail(widget.chonkangId);
    final tripInfoFuture = TravelRoomApi.instance.fetchTripInfo(widget.chonkangId);
    final accommodationsFuture = TravelRoomApi.instance.fetchAllRecommendedAccommodations(
      widget.chonkangId,
    );

    final detail = await detailFuture;
    final tripInfo = await tripInfoFuture;
    final accommodations = await accommodationsFuture;

    return MoodAccommodationPageData(
      moodName: detail.name,
      moodTags: _topMoodTags(detail),
      travelInfo: _travelInfo(tripInfo),
      topAccommodations: accommodations.take(_topAccommodationCount).toList(),
      similarAccommodations: accommodations.skip(_topAccommodationCount).toList(),
    );
  }

  List<String> _topMoodTags(MoodResultDetail detail) {
    final sorted = [...detail.tagBreakdown]
      ..sort((a, b) => b.voteCount.compareTo(a.voteCount));
    return sorted.take(_moodTagCount).map((tag) => tag.tag).toList();
  }

  List<String> _travelInfo(ChonkangTripInfo tripInfo) {
    return [
      '${tripInfo.plannedMemberCount}명',
      if (tripInfo.companionType != null) companionTypeLabels[tripInfo.companionType]!,
      if (tripInfo.travelMethod != null) travelMethodLabels[tripInfo.travelMethod]!,
      if (tripInfo.desiredRegion != null) regionLabels[tripInfo.desiredRegion]!,
    ];
  }

  void _retry() {
    setState(() {
      _dataFuture = _fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MoodAccommodationPageData>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('숙소 정보를 불러오지 못했어요.'),
                  const SizedBox(height: 12),
                  TextButton(onPressed: _retry, child: const Text('다시 시도')),
                ],
              ),
            ),
          );
        }

        return MoodAccommodationPage(
          data: snapshot.data!,
          chonkangId: widget.chonkangId,
        );
      },
    );
  }
}
