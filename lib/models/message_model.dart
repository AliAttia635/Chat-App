import 'dart:io';

import 'package:chatapp/constats/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String message;
  final String id;
  final Timestamp date;
  // final String image;
  String imageFileUrl;

  MessageModel(
      {required this.message,
      required this.id,
      required this.date,
      required this.imageFileUrl});

  factory MessageModel.fromJson(jsonData) {
    return MessageModel(
        message: jsonData[Kmessage],
        id: jsonData['id'],
        date: jsonData[KcreatedAt],
        // image :jsonData[KImage],
        imageFileUrl: jsonData[KImageUrl] ?? '');
  }
}
