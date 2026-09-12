import 'package:flutter/material.dart';

import '../data/travel_room_api.dart';
import '../models/mood_result.dart';
import 'mood_result_detail_page.dart';

// MoodResultDetailPage는 완성된 MoodResult를 그리기만 하는 화면이라, memberCount는
// mood-result/detail에 없어서 trip-info(currentMemberCount)를 같이 불러와 합친다.
class MoodResultDetailLoaderPage extends StatefulWidget {
  const MoodResultDetailLoaderPage({
    super.key,
    required this.chonkangId,
    this.showAccommodationButton = true,
  });

  final int chonkangId;
  final bool showAccommodationButton;

  @override
  State<MoodResultDetailLoaderPage> createState() => _MoodResultDetailLoaderPageState();
}

class _MoodResultDetailLoaderPageState extends State<MoodResultDetailLoaderPage> {
  late Future<MoodResult> _resultFuture;

  @override
  void initState() {
    super.initState();
    _resultFuture = _fetch();
  }

  Future<MoodResult> _fetch() async {
    final detailFuture = TravelRoomApi.instance.fetchMoodResultDetail(widget.chonkangId);
    final tripInfoFuture = TravelRoomApi.instance.fetchTripInfo(widget.chonkangId);
    final detail = await detailFuture;
    final tripInfo = await tripInfoFuture;

    return MoodResult(
      moodName: detail.name,
      description: detail.description,
      imageUrls: detail.collageImageUrls.take(4).toList(),
      memberCount: tripInfo.currentMemberCount,
      voteResults: detail.tagBreakdown,
      reason: detail.summary,
    );
  }

  void _retry() {
    setState(() {
      _resultFuture = _fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MoodResult>(
      future: _resultFuture,
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
                  const Text('무드 결과를 불러오지 못했어요.'),
                  const SizedBox(height: 12),
                  TextButton(onPressed: _retry, child: const Text('다시 시도')),
                ],
              ),
            ),
          );
        }

        return MoodResultDetailPage(
          result: snapshot.data!,
          showAccommodationButton: widget.showAccommodationButton,
        );
      },
    );
  }
}
