import 'package:flutter/material.dart';

abstract final class AppShadows {
  static const List<BoxShadow> base = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.04),
      offset: Offset(0, 0),
      blurRadius: 11.8,
      spreadRadius: 2,
    ),
  ];

  static const List<BoxShadow> tab = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.04),
      offset: Offset(0, 4),
      blurRadius: 12.9,
      spreadRadius: 3,
    ),
  ];

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.06),
      offset: Offset(0, 0),
      blurRadius: 24.3,
      spreadRadius: 4,
    ),
  ];

  static const List<BoxShadow> notification = [
    BoxShadow(
      color: Color.fromRGBO(47, 47, 47, 0.03),
      offset: Offset(0, 0),
      blurRadius: 17.6,
      spreadRadius: 2,
    ),
  ];
}
