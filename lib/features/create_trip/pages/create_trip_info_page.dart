import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/button/green/green_button.dart';
import '../../../core/widgets/button/green/green_button_size.dart';
import '../../../core/widgets/character/character.dart';
import '../../../core/widgets/character/character_size.dart';
import '../../../core/widgets/character/character_type.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../models/create_trip_form_section.dart';
import '../widgets/create_trip_form_field.dart';
import '../widgets/create_trip_intro_header.dart';

class CreateTripInfoPage extends StatefulWidget {
  const CreateTripInfoPage({super.key});

  @override
  State<CreateTripInfoPage> createState() => _CreateTripInfoPageState();
}

class _CreateTripInfoPageState extends State<CreateTripInfoPage> {
  final TextEditingController _nameController = TextEditingController();
  CreateTripFormSection _expandedSection = CreateTripFormSection.name;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _expand(CreateTripFormSection section) {
    setState(() {
      _expandedSection = section;
    });
  }

  void _goToMoodSelection() {
    // TODO: validate required fields and navigate to mood selection.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            TopBar(
              type: TopBarType.title,
              title: '촌캉스 만들기',
              onBack: () => Navigator.of(context).pop(),
            ),
            Positioned(
              right: 2,
              top: 65,
              child: IgnorePointer(
                child: Character(
                  type: CharacterType.notebook,
                  size: CharacterSize.medium,
                  width: 89,
                  height: 89,
                ),
              ),
            ),
            Positioned.fill(
              top: 72,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 47),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CreateTripIntroHeader(
                      eyebrow: '여행 정보',
                      title: '어떤 촌캉스를 떠나볼까요?',
                      description: '입력한 정보는 구성원 모두에게 동일하게 반영돼요.',
                    ),
                    const SizedBox(height: 28),
                    _CreateTripInfoForm(
                      expandedSection: _expandedSection,
                      nameController: _nameController,
                      onSectionTap: _expand,
                    ),
                    const SizedBox(height: 34),
                    GreenButton(
                      size: GreenButtonSize.long,
                      label: '무드 선택하러 가기',
                      onTap: _goToMoodSelection,
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

class _CreateTripInfoForm extends StatelessWidget {
  const _CreateTripInfoForm({
    required this.expandedSection,
    required this.nameController,
    required this.onSectionTap,
  });

  final CreateTripFormSection expandedSection;
  final TextEditingController nameController;
  final ValueChanged<CreateTripFormSection> onSectionTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final section in CreateTripFormSection.values) ...[
          CreateTripFormField(
            section: section,
            expanded: expandedSection == section,
            onTap: () => onSectionTap(section),
            child: section == CreateTripFormSection.name
                ? CreateTripNameField(controller: nameController)
                : null,
          ),
          if (section != CreateTripFormSection.values.last)
            const SizedBox(height: 16),
        ],
      ],
    );
  }
}
