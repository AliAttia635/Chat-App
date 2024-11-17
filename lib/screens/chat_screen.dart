import 'dart:developer';
import 'dart:io';

import 'package:chatapp/constats/constant.dart';
import 'package:chatapp/cubit/chat_cubit/chat_cubit.dart';
import 'package:chatapp/models/message_model.dart';
import 'package:chatapp/widgets/ChatBubble.dart';
import 'package:chatapp/widgets/ChatBubbleForFirend.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ChatPage extends StatefulWidget {
  ChatPage({super.key});
  static String id = "ChatPage";

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = ScrollController();
  File? _pickedFile;
  String imageUrl = ''; // Initialize imageUrl as an empty string
  TextEditingController textController = TextEditingController();
  CollectionReference messages =
      FirebaseFirestore.instance.collection(KcollectionMessages);

  bool isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ChatCubit>(context).loadMessages();
  }

  void pickImage() async {
    try {
      XFile? pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      setState(() {
        _pickedFile = File(pickedFile.path); // Set the picked file for preview
        isButtonDisabled = textController.text.isEmpty &&
            _pickedFile == null; // Update button state
      });

      // If you want to upload the image later after pressing the send button, move the upload logic to the send button's onPressed
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;
    ChatCubit myCubit = BlocProvider.of<ChatCubit>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Quick Chat"),
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return Center(
              child: Text("Chats Loading"),
            );
          } else if (state is ChatLoaded) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: myCubit.messagesList!.length,
                      itemBuilder: (contex, index) {
                        return myCubit.messagesList![index].id == email
                            ? CustomChatBubble(
                                messageModel: myCubit.messagesList![index])
                            : ChatBubbleForFriend(
                                messageModel: myCubit.messagesList![index]);
                      }),
                ),
                if (_pickedFile != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Image.file(
                          _pickedFile!,
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.cancel, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _pickedFile = null; // Remove the image preview
                                isButtonDisabled = textController.text.isEmpty;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: textController,
                    onSubmitted: (data) {
                      textController.clear();
                    },
                    decoration: InputDecoration(
                      hintText: "Send Message",
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: pickImage,
                            icon: Icon(Icons.attach_file, color: KprimaryColor),
                          ),
                          SizedBox(width: 5),
                          IconButton(
                            onPressed: () {
                              myCubit.sendMessage(
                                  _pickedFile, imageUrl, textController, email);
                              // Clear after sending the message
                            },
                            icon: Icon(Icons.send),
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Text("Opps Error "),
            );
          }
        },
      ),
    );
  }
}
