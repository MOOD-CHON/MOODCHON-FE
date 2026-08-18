import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'character_size.dart';
import 'character_type.dart';

class Character extends StatelessWidget {
  const Character({
    super.key,
    required this.type,
    required this.size,
    this.width,
    this.height,
    this.semanticLabel,
  });

  final CharacterType type;
  final CharacterSize size;
  final double? width;
  final double? height;
  final String? semanticLabel;

  String get _typePath {
    switch (type) {
      case CharacterType.defaultCharacter:
        return 'default';
      case CharacterType.greeting:
        return 'greeting';
      case CharacterType.excited:
        return 'excited';
      case CharacterType.confused:
        return 'confused';
      case CharacterType.sad:
        return 'sad';
      case CharacterType.letter:
        return 'letter';
      case CharacterType.notebook:
        return 'notebook';
    }
  }

  String get _sizePath {
    switch (size) {
      case CharacterSize.smaller:
        return 'smaller';
      case CharacterSize.small:
        return 'small';
      case CharacterSize.medium:
        return 'medium';
      case CharacterSize.large:
        return 'large';
      case CharacterSize.extraLarge:
        return 'extra_large';
    }
  }

  bool get _isSupported {
    switch (type) {
      case CharacterType.defaultCharacter:
        return size == CharacterSize.small || size == CharacterSize.medium;

      case CharacterType.greeting:
        return size == CharacterSize.small ||
            size == CharacterSize.medium ||
            size == CharacterSize.large;

      case CharacterType.excited:
      case CharacterType.confused:
        return size == CharacterSize.small ||
            size == CharacterSize.medium ||
            size == CharacterSize.extraLarge;

      case CharacterType.sad:
      case CharacterType.letter:
        return size == CharacterSize.small || size == CharacterSize.medium;

      case CharacterType.notebook:
        return size == CharacterSize.smaller || size == CharacterSize.medium;
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(
      _isSupported,
      '${type.name} Character에는 ${size.name} 사이즈가 정의되어 있지 않습니다.',
    );

    return SvgPicture.asset(
      'assets/images/character/$_typePath/$_sizePath.svg',
      width: width,
      height: height,
      semanticsLabel: semanticLabel,
      excludeFromSemantics: semanticLabel == null,
    );
  }
}
