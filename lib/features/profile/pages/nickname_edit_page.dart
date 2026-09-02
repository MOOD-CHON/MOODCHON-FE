import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/button/green/green_button.dart';
import '../../../core/widgets/button/green/green_button_size.dart';
import '../../../core/widgets/inputs/text_field/moodchon_text_field.dart';
import '../../../core/widgets/inputs/text_field/text_field_size.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../../../core/widgets/text/warning_text.dart';

class NicknameEditPage extends StatefulWidget {
  const NicknameEditPage({super.key, required this.initialNickname});

  final String initialNickname;

  @override
  State<NicknameEditPage> createState() => _NicknameEditPageState();
}

class _NicknameEditPageState extends State<NicknameEditPage> {
  late final TextEditingController _controller;

  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.initialNickname);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleChanged(String value) {
    if (_hasError && value.trim().isNotEmpty) {
      setState(() {
        _hasError = false;
      });
    }
  }

  void _handleSave() {
    final nickname = _controller.text.trim();

    if (nickname.isEmpty) {
      setState(() {
        _hasError = true;
      });
      return;
    }

    Navigator.of(context).pop<String>(nickname);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            TopBar(
              type: TopBarType.title,
              title: '닉네임 수정하기',
              onBack: () {
                Navigator.of(context).pop();
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '무드촌에서 사용할 닉네임을 입력해주세요.',
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '*',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.statusError,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    MoodChonTextField(
                      size: MoodChonTextFieldSize.long,
                      controller: _controller,
                      placeholder: '닉네임을 6자 이내로 입력해주세요.',
                      maxLength: 6,
                      hasError: _hasError,
                      onChanged: _handleChanged,
                    ),
                    if (_hasError) ...[
                      const SizedBox(height: 13),
                      const WarningText(text: '닉네임을 입력해주세요.'),
                    ],
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: GreenButton(
                        size: GreenButtonSize.long,
                        label: '저장하기',
                        onTap: _handleSave,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
