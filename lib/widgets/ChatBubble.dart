import 'package:chatapp/constats/constant.dart';
import 'package:chatapp/models/message_model.dart';
import 'package:flutter/material.dart';

class CustomChatBubble extends StatelessWidget {
  CustomChatBubble({
    super.key,
    required this.message,
  });

  MessageModel message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: EdgeInsets.all(16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(27),
              topRight: Radius.circular(27),
              bottomRight: Radius.circular(27)),
          color: KprimaryColor,
        ),
        child: Text(
          message.message,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
