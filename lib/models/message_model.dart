import 'package:chatapp/constats/constant.dart';

class MessageModel {
  final String message;

  MessageModel({required this.message});

  factory MessageModel.fromJson(jsonData) {
    return MessageModel(message: jsonData[Kmessage]);
  }
}
