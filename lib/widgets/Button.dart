// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  String text;
  VoidCallback? ontap;

  CustomButton({
    required this.text,
    this.ontap
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        width: double.infinity,
        height: 40,
        child: Center(
          child: Text(
            text!,
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
