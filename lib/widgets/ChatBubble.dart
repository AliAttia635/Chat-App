import 'package:chatapp/constats/constant.dart';
import 'package:chatapp/models/message_model.dart';
import 'package:flutter/material.dart';

class CustomChatBubble extends StatelessWidget {
  CustomChatBubble({
    super.key,
    required this.messageModel,
  });

  MessageModel messageModel;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: messageModel.message.isEmpty ? null : EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(27),
              topRight: Radius.circular(27),
              bottomLeft: Radius.circular(27)),
          color: messageModel.message.isEmpty ? Colors.black : KprimaryColor,
        ),
        child: messageModel.message.isEmpty
            ? messageModel.imageFileUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(
                      messageModel.imageFileUrl,
                      width: 250,
                    ),
                  )
                : Container()
            : Text(
                messageModel.message,
                style: TextStyle(color: Colors.white),
              ),
      ),
    );
  }
}
