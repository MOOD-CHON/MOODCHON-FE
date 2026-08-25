import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CopyIcon extends StatelessWidget {
  const CopyIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('assets/icons/copy.svg', width: 9, height: 10);
  }
}
