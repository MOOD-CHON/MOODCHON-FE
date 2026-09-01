import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum PinIconSize { medium, small }

class PinIcon extends StatelessWidget {
  const PinIcon({super.key, required this.size});

  final PinIconSize size;

  String get _assetPath {
    switch (size) {
      case PinIconSize.medium:
        return 'assets/icons/pin/medium.svg';
      case PinIconSize.small:
        return 'assets/icons/pin/small.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(_assetPath, fit: BoxFit.contain);
  }
}
