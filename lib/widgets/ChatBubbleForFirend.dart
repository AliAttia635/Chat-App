import 'package:chatapp/constats/constant.dart';
import 'package:chatapp/models/message_model.dart';
import 'package:flutter/material.dart';

class ChatBubbleForFriend extends StatelessWidget {
  ChatBubbleForFriend({
    super.key,
    required this.messageModel,
  });

  MessageModel messageModel;

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
          color: Colors.green,
        ),
        child: Text(
          messageModel.message,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
