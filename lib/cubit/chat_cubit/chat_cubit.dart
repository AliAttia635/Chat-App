import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:chatapp/constats/constant.dart';
import 'package:chatapp/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  // Reference to the messages collection in Firestore
  CollectionReference messagesRefrence =
      FirebaseFirestore.instance.collection(KcollectionMessages);
  List<MessageModel> messagesList = [];
  File? pickedImage;

  Future<void> getMessages() {
    messagesList.clear();
    messagesRefrence
        .orderBy(KcreatedAt, descending: false)
        .snapshots()
        .listen((event) {
      for (var doc in event.docs) {
        messagesList.add(MessageModel.fromJson(doc));
      }
      emit(ChatLoaded());
    });
    return Future.value();
  }

  Future<void> pickImage() async {
    try {
      XFile? pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        pickedImage = File(pickedFile.path);
        emit(ChatImageSelected(pickedImage!)); // Emit image selected state
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void clearImage() {
    pickedImage = null;
    emit(ChatImageCleared()); // Emit image cleared state
  }

  Future<void> sendMessage(
      File? imageFile, String messageText, var email) async {
    String? imageUrl;

    // Upload image if one was picked
    if (imageFile != null) {
      String uniqueImageFileName =
          DateTime.now().microsecondsSinceEpoch.toString();
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('images');
      Reference referenceImageToUpload =
          referenceDirImages.child(uniqueImageFileName);

      try {
        await referenceImageToUpload.putFile(imageFile);
        imageUrl = await referenceImageToUpload.getDownloadURL();
      } catch (e) {
        print('Error uploading image: $e');
      }
    }

    // Add message to Firestore with image URL if available
    await messagesRefrence.add({
      Kmessage: messageText,
      KcreatedAt: DateTime.now(),
      'id': email,
      KImageUrl: imageUrl,
    });

    // Clear the selected image before emitting ChatLoaded state
    if (pickedImage != null) {
      clearImage(); // This will emit ChatImageCleared
    }

    // Emit the loaded state after the image is cleared
    QuerySnapshot snapshot =
        await messagesRefrence.orderBy(KcreatedAt, descending: false).get();
    messagesList =
        snapshot.docs.map((doc) => MessageModel.fromJson(doc)).toList();
    emit(ChatLoaded()); // Emit state to refresh UI
  }
}
