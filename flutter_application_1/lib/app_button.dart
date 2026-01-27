import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String buttontext;
  final VoidCallback ontap;
  final Color backgroundColor;
  final double height;
  final double width;
  final Color buttontextclr;

  const AppButton({
    super.key,
    required this.buttontext,
    required this.ontap,
    required this.backgroundColor,
    required this.height,
    required this.width,
    required this.buttontextclr,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: 400,
        height: 60,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Center(
          child: Text(
            buttontext,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color.fromARGB(255, 244, 242, 242),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
