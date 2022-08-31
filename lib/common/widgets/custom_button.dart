import 'package:flutter/material.dart';
import 'package:not_whatsapp/constants/colors.dart';
import 'package:not_whatsapp/constants/font_styles.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Function() onTap;
  const CustomButton({
    Key? key,
    required this.buttonText,
    required this.buttonColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        MediaQuery.of(context).size.height * 0.01,
      ),
      child: ElevatedButton(
          onPressed: onTap,
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.08,
            child: Text(
              buttonText,
              style: FontStyle.h2(context),
            ),
          )),
    );
  }
}
