import 'package:flutter/material.dart';

class ScreenType extends StatelessWidget {
  final Widget mobile;
  final Widget web;
  const ScreenType({
    Key? key,
    required this.mobile,
    required this.web,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return web;
        } else {
          return mobile;
        }
      },
    );
  }
}
