import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../data/legal_documents.dart';

class LegalDocumentPage extends StatelessWidget {
  const LegalDocumentPage({
    super.key,
    required this.title,
    required this.blocks,
  });

  final String title;
  final List<LegalTextBlock> blocks;

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
              title: title,
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
                    for (final block in blocks) _LegalText(block: block),
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

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalDocumentPage(
      title: '서비스 이용약관',
      blocks: LegalDocuments.termsOfService,
    );
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalDocumentPage(
      title: '개인정보 안내',
      blocks: LegalDocuments.privacyPolicy,
    );
  }
}

class _LegalText extends StatelessWidget {
  const _LegalText({required this.block});

  final LegalTextBlock block;

  @override
  Widget build(BuildContext context) {
    if (block.text.isEmpty) {
      return const SizedBox(height: 19.2);
    }

    final bodyStyle = AppTypography.captionMedium.copyWith(
      color: AppColors.textSecondary,
    );
    final sectionStyle = AppTypography.titleMedium.copyWith(
      color: AppColors.textSecondary,
      height: 1.6,
    );
    final subsectionStyle = AppTypography.titleSmall.copyWith(
      color: AppColors.textSecondary,
      height: 1.6,
    );

    return Text(
      block.text,
      style: switch (block.level) {
        LegalTextLevel.body => bodyStyle,
        LegalTextLevel.section => sectionStyle,
        LegalTextLevel.subsection => subsectionStyle,
      },
    );
  }
}
