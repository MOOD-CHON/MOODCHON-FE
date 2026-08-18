import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class WarningText extends StatelessWidget {
  const WarningText({super.key, required this.text});

  final String text;

  static const double _iconTextGap = 3;

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTypography.tabLarge.copyWith(
      color: AppColors.statusError,
    );

    return Semantics(
      label: text,
      child: SizedBox(
        width: double.infinity,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final textPainter = TextPainter(
              text: TextSpan(text: text, style: textStyle),
              textDirection: TextDirection.ltr,
              textScaler: MediaQuery.textScalerOf(context),
              maxLines: null,
            )..layout(maxWidth: constraints.maxWidth - 17 - _iconTextGap);

            final isMultiLine = textPainter.computeLineMetrics().length > 1;

            return Row(
              crossAxisAlignment: isMultiLine
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: isMultiLine ? 1.5 : 0),
                  child: ExcludeSemantics(
                    child: SvgPicture.asset('assets/icons/warning.svg'),
                  ),
                ),
                const SizedBox(width: _iconTextGap),
                Expanded(
                  child: ExcludeSemantics(
                    child: Text(
                      text,
                      textAlign: TextAlign.left,
                      style: textStyle,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
