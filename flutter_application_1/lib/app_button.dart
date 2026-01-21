import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String buttontext;
  AppButton({super.key, required this.buttontext});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Center(
        child: Text(
          buttontext,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
