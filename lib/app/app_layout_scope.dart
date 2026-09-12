import 'package:flutter/widgets.dart';

class AppLayoutScope extends InheritedWidget {
  const AppLayoutScope({
    super.key,
    required this.isDesktopWeb,
    required super.child,
  });

  final bool isDesktopWeb;

  static AppLayoutScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppLayoutScope>();

    assert(scope != null, 'AppLayoutScope가 위젯 트리에 존재하지 않습니다.');

    return scope!;
  }

  @override
  bool updateShouldNotify(AppLayoutScope oldWidget) {
    return oldWidget.isDesktopWeb != isDesktopWeb;
  }
}
