import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chatapp/constats/constant.dart';
import 'package:chatapp/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  CollectionReference messages =
      FirebaseFirestore.instance.collection(KcollectionMessages);

  List<MessageModel>? messagesList;

  loadMessages() async {
    try {
      emit(ChatLoading());
      QuerySnapshot snapshot =
          await messages.orderBy(KcreatedAt, descending: false).get();
      messagesList =
          snapshot.docs.map((doc) => MessageModel.fromJson(doc)).toList();
      emit(ChatLoaded());
    } catch (e) {
      emit(ChatFailed());
    }
  }

  sendMessage(File? _pickedFile, String imageUrl,
      TextEditingController textController, var email) async {
    // If an image is selected, upload it now
    if (_pickedFile != null) {
      String uniqueImageFileName =
          DateTime.now().microsecondsSinceEpoch.toString();
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('images');
      Reference referenceImageToUpload =
          referenceDirImages.child(uniqueImageFileName);

      await referenceImageToUpload.putFile(_pickedFile!);
      imageUrl = await referenceImageToUpload.getDownloadURL();
    }

    // Send the message with imageUrl if available
    messages.add({
      Kmessage: textController.text,
      KcreatedAt: DateTime.now(),
      'id': email,
      KImageUrl: imageUrl,
    });

    // Clear after sending the message
    textController.clear();

    _pickedFile = null;
    imageUrl = ''; // Reset the image URL

    loadMessages();
  }
}
