import 'package:flutter/material.dart';

import '../data/travel_room_api.dart';
import '../models/travel_room_main_data.dart';
import 'travel_room_main_page.dart';

// TravelRoomMainPage는 이미 만들어진 TravelRoomMainData를 받아 그리기만 하는
// StatelessWidget이라, 실제 API 호출과 로딩/에러 처리는 이 화면이 맡는다.
class TravelRoomMainLoaderPage extends StatefulWidget {
  const TravelRoomMainLoaderPage({super.key, required this.chonkangId});

  final int chonkangId;

  @override
  State<TravelRoomMainLoaderPage> createState() => _TravelRoomMainLoaderPageState();
}

class _TravelRoomMainLoaderPageState extends State<TravelRoomMainLoaderPage> {
  late Future<TravelRoomMainData> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = TravelRoomApi.instance.fetchMain(widget.chonkangId);
  }

  void _retry() {
    setState(() {
      _dataFuture = TravelRoomApi.instance.fetchMain(widget.chonkangId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TravelRoomMainData>(
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
                  const Text('여행방 정보를 불러오지 못했어요.'),
                  const SizedBox(height: 12),
                  TextButton(onPressed: _retry, child: const Text('다시 시도')),
                ],
              ),
            ),
          );
        }

        return TravelRoomMainPage(chonkangId: widget.chonkangId, data: snapshot.data!);
      },
    );
  }
}
