import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../base/circle_button_background/circle_button_background_medium.dart';
import '../base/circle_button_background/circle_button_background_type.dart';

class TrashBackgroundButton extends StatelessWidget {
  const TrashBackgroundButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: CircleButtonBackgroundMedium(
        type: CircleButtonBackgroundType.white,
        child: SvgPicture.asset('assets/icons/trash/trash_small.svg'),
      ),
    );
  }
}
