import 'package:flutter/material.dart';
import 'package:not_whatsapp/constants/font_styles.dart';

class ErrorScreen extends StatelessWidget {
  final String error;
  const ErrorScreen({
    Key? key,
    required this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        error,
        style: FontStyle.h1Bold(context),
      ),
    );
  }
}
