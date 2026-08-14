import 'package:flutter/material.dart';

abstract final class AppTypography {
  static const String _pretendard = 'Pretendard';
  static const String _poppins = 'Poppins';
  static const String _onboarding = 'MemomentK';

  // Title

  static const TextStyle titlePlace = TextStyle(
    fontFamily: _pretendard,
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle titleInfo = TextStyle(
    fontFamily: _pretendard,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: 20 * 0.03,
  );

  static const TextStyle titleMood = TextStyle(
    fontFamily: _pretendard,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: 20 * -0.03,
  );

  static const TextStyle titleNav = TextStyle(
    fontFamily: _pretendard,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 18 * -0.03,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: _pretendard,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    letterSpacing: 18 * -0.03,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: _pretendard,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: _pretendard,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  // Caption

  static const TextStyle captionOnboarding = TextStyle(
    fontFamily: _onboarding,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    letterSpacing: 18 * 0.06,
  );

  static const TextStyle captionExtraLarge = TextStyle(
    fontFamily: _pretendard,
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle captionPlace = TextStyle(
    fontFamily: _pretendard,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 14 * -0.02,
  );

  static const TextStyle captionLarge = TextStyle(
    fontFamily: _pretendard,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 12 * -0.02,
  );

  static const TextStyle captionMedium = TextStyle(
    fontFamily: _pretendard,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.6,
  );

  static const TextStyle captionSmall = TextStyle(
    fontFamily: _pretendard,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const TextStyle captionExtraSmall = TextStyle(
    fontFamily: _pretendard,
    fontSize: 10,
    fontWeight: FontWeight.w400,
  );

  // Description

  static const TextStyle descriptionLarge = TextStyle(
    fontFamily: _pretendard,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 14 * 0.01,
  );

  static const TextStyle descriptionMedium = TextStyle(
    fontFamily: _pretendard,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 14 * 0.01,
  );

  static const TextStyle descriptionSmall = TextStyle(
    fontFamily: _pretendard,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  // Date

  static const TextStyle dateLarge = TextStyle(
    fontFamily: _pretendard,
    fontSize: 17,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 17 * 0.02,
  );

  static const TextStyle dateMedium = TextStyle(
    fontFamily: _poppins,
    fontSize: 13.4,
    fontWeight: FontWeight.w400,
    letterSpacing: 13.4 * -0.02,
  );

  static const TextStyle dateSmall = TextStyle(
    fontFamily: _pretendard,
    fontSize: 8.5,
    fontWeight: FontWeight.w500,
    height: 1,
  );

  static const TextStyle dateExtraSmall = TextStyle(
    fontFamily: _poppins,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 1,
  );

  // Tab

  static const TextStyle tabLarge = TextStyle(
    fontFamily: _pretendard,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle tabMedium = TextStyle(
    fontFamily: _pretendard,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle tabSmall = TextStyle(
    fontFamily: _pretendard,
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  // Body

  static const TextStyle bodyPlace = TextStyle(
    fontFamily: _pretendard,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyMood = TextStyle(
    fontFamily: _pretendard,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyExtraLarge = TextStyle(
    fontFamily: _pretendard,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _pretendard,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.8,
    letterSpacing: 13 * -0.02,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _pretendard,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _pretendard,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: 12 * -0.02,
  );

  static const TextStyle bodyProfile = TextStyle(
    fontFamily: _pretendard,
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyMap = TextStyle(
    fontFamily: _pretendard,
    fontSize: 10,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle bodyLabel = TextStyle(
    fontFamily: _pretendard,
    fontSize: 9,
    fontWeight: FontWeight.w500,
  );
}
