import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/banner/toast_overlay.dart';
import '../../../core/widgets/button/green/green_button.dart';
import '../../../core/widgets/button/green/green_button_size.dart';
import '../../../core/widgets/inputs/text_field/moodchon_text_field.dart';
import '../../../core/widgets/inputs/text_field/text_field_size.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../../../core/widgets/text/warning_text.dart';
import '../../chonkang_join/widgets/option_chip.dart';
import '../data/itinerary_api.dart';
import '../models/itinerary_place_category.dart';

/// 9.3.1-2 장소 없이 추가하기 / 9.3.1-3 유효성 검사.
class AddCustomItineraryItemPage extends StatefulWidget {
  const AddCustomItineraryItemPage({
    super.key,
    required this.chonkangId,
    required this.dayNumber,
  });

  final int chonkangId;
  final int dayNumber;

  @override
  State<AddCustomItineraryItemPage> createState() =>
      _AddCustomItineraryItemPageState();
}

class _AddCustomItineraryItemPageState
    extends State<AddCustomItineraryItemPage> {
  final TextEditingController _nameController = TextEditingController();

  ItineraryPlaceCategory? _category;
  bool _isSubmitting = false;

  bool _showNameError = false;
  bool _showCategoryError = false;

  static const int _maxNameLength = 20;

  @override
  void initState() {
    super.initState();

    _nameController.addListener(() {
      if (_showNameError && _nameController.text.trim().isNotEmpty) {
        setState(() {
          _showNameError = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();

    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final name = _nameController.text.trim();
    final category = _category;

    final nameInvalid = name.isEmpty;
    final categoryInvalid = category == null;

    if (nameInvalid || categoryInvalid) {
      setState(() {
        _showNameError = nameInvalid;
        _showCategoryError = categoryInvalid;
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ItineraryApi.addCustomItem(
        widget.chonkangId,
        dayNumber: widget.dayNumber,
        name: name,
        category: category,
      );

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } on ApiException catch (error) {
      if (mounted) {
        ToastOverlay.show(context, message: error.message, bottom: 96);
        setState(() {
          _isSubmitting = false;
        });
      }
    }
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
              type: TopBarType.title,
              title: '장소 없이 추가하기',
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Label('일정명'),
                    const SizedBox(height: 8),
                    MoodChonTextField(
                      size: MoodChonTextFieldSize.long,
                      placeholder: '예) 숙소 주변 산책하기',
                      controller: _nameController,
                      hasError: _showNameError,
                      maxLength: _maxNameLength,
                    ),
                    if (_showNameError) ...[
                      const SizedBox(height: 6),
                      const WarningText(text: '일정명을 입력해주세요.'),
                    ],
                    const SizedBox(height: 24),
                    _Label('활동 유형'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ItineraryPlaceCategory.values.map((category) {
                        return OptionChip(
                          label: category.label,
                          selected: _category == category,
                          onTap: () {
                            setState(() {
                              _category = category;
                              _showCategoryError = false;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    if (_showCategoryError) ...[
                      const SizedBox(height: 6),
                      const WarningText(text: '활동 유형을 선택해주세요.'),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: GreenButton(
                size: GreenButtonSize.long,
                label: '일정에 추가하기',
                onTap: _isSubmitting ? () {} : _handleSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: AppTypography.titleSmall.copyWith(color: AppColors.black),
        children: [
          TextSpan(text: text),
          TextSpan(
            text: ' *',
            style: TextStyle(color: AppColors.statusError),
          ),
        ],
      ),
    );
  }
}
