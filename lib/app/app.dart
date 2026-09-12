import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app_entry_point.dart';
import 'app_layout_scope.dart';
import 'theme/app_theme.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class MoodChonApp extends StatelessWidget {
  const MoodChonApp({super.key});

  static const double _designWidth = 393;
  static const double _designHeight = 852;
  static const double _mobileWebBreakpoint = 500;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: rootNavigatorKey,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      builder: (context, child) {
        if (child == null) {
          return const SizedBox.shrink();
        }

        final content = GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: child,
        );

        final screenSize = MediaQuery.sizeOf(context);

        final isDesktopWeb = kIsWeb && screenSize.width >= _mobileWebBreakpoint;

        // iOS / Android 앱
        if (!kIsWeb) {
          return AppLayoutScope(isDesktopWeb: false, child: content);
        }

        // 모바일 웹
        if (!isDesktopWeb) {
          return AppLayoutScope(isDesktopWeb: false, child: content);
        }

        // 데스크톱 / 태블릿 웹
        return AppLayoutScope(
          isDesktopWeb: true,
          child: ColoredBox(
            color: const Color(0xFFF3F3F3),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final verticalPadding = constraints.maxHeight > _designHeight
                    ? (constraints.maxHeight - _designHeight) / 2
                    : 0.0;

                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: verticalPadding),
                    child: Center(
                      child: SizedBox(
                        width: _designWidth,
                        height: _designHeight,
                        child: MediaQuery(
                          data: MediaQuery.of(context).copyWith(
                            size: const Size(_designWidth, _designHeight),
                          ),
                          child: ClipRect(child: content),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
      home: const AppEntryPoint(),
    );
  }
}

// 로그아웃/탈퇴/세션 만료 시 지금까지 쌓인 화면 스택을 전부 걷어내고
// 로그인 여부를 다시 판단하는 진입 지점으로 되돌아간다.
void navigateToLogin() {
  rootNavigatorKey.currentState?.pushAndRemoveUntil(
    MaterialPageRoute<void>(builder: (_) => const AppEntryPoint()),
    (route) => false,
  );
}
