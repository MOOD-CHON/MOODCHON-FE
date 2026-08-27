import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../base/circle_button_background/circle_button_background_medium.dart';
import '../base/circle_button_background/circle_button_background_type.dart';

class GoBackgroundButton extends StatelessWidget {
  const GoBackgroundButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '이동',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: CircleButtonBackgroundMedium(
          type: CircleButtonBackgroundType.ivory,
          child: SvgPicture.asset(
            'assets/icons/arrow_go/arrow_go_medium_green.svg',
          ),
        ),
      ),
    );
  }
}
