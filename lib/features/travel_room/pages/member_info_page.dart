import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../data/travel_room_settings_api.dart';
import '../models/chonkang_member.dart';
import 'edit_trip_info_page.dart';

class MemberInfoPage extends StatefulWidget {
  const MemberInfoPage({
    super.key,
    required this.chonkangId,
    required this.roomName,
    required this.travelDateText,
  });

  final int chonkangId;
  final String roomName;
  final String travelDateText;

  @override
  State<MemberInfoPage> createState() => _MemberInfoPageState();
}

class _MemberInfoPageState extends State<MemberInfoPage> {
  bool _isLoading = true;
  String? _errorMessage;
  List<ChonkangMember> _members = const [];

  @override
  void initState() {
    super.initState();

    _fetchMembers();
  }

  Future<void> _fetchMembers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final members = await TravelRoomSettingsApi.getMembers(
        widget.chonkangId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _members = members;
      });
    } on ApiException catch (error) {
      setState(() {
        _errorMessage = error.message;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onEditInfoTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EditTripInfoPage(chonkangId: widget.chonkangId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            TopBar(
              type: TopBarType.date,
              title: widget.roomName,
              date: widget.travelDateText,
              onBack: () {
                Navigator.of(context).pop();
              },
            ),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.main),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          style: AppTypography.bodyExtraLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _onEditInfoTap,
            child: Row(
              children: [
                Text(
                  '정보 수정',
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 6),
                SvgPicture.asset(
                  'assets/icons/arrow_go/arrow_go_small_black.svg',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          for (final member in _members) ...[
            _MemberRow(member: member),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

class _MemberRow extends StatelessWidget {
  const _MemberRow({required this.member});

  final ChonkangMember member;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MemberAvatar(imageUrl: member.profileImageUrl),
        const SizedBox(width: 10),
        Text(
          member.nickname,
          style: AppTypography.bodyExtraLarge.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        if (member.isHost) ...[
          const SizedBox(width: 6),
          Text(
            '방장',
            style: AppTypography.captionMedium.copyWith(
              color: AppColors.main,
            ),
          ),
        ],
      ],
    );
  }
}

class _MemberAvatar extends StatelessWidget {
  const _MemberAvatar({required this.imageUrl});

  final String? imageUrl;

  static const double _size = 24;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim();

    return ClipOval(
      child: SizedBox(
        width: _size,
        height: _size,
        child: url != null && url.isNotEmpty
            ? Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/empty_state/empty_profile.png',
                    fit: BoxFit.cover,
                  );
                },
              )
            : Image.asset(
                'assets/images/empty_state/empty_profile.png',
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
