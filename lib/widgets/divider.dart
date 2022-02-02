import 'package:flutter/material.dart';

Widget gradientDivider(
    {double height, double margin, double startIndent, double endIndent}) {
  return Container(
    margin: EdgeInsetsDirectional.only(
        start: margin ?? startIndent ?? 0, end: margin ?? endIndent ?? 0),
    decoration: BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Colors.yellow[600], Colors.red]),
    ),
    height: height ?? 2,
  );
}
