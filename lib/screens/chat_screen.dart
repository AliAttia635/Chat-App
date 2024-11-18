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

class ChatPage extends StatelessWidget {
  ChatPage({super.key});
  static String id = "ChatPage";

  // final _controller = ScrollController();

  TextEditingController textController = TextEditingController();

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
            }
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
                if (state
                    is ChatImageSelected) // Display image preview if an image is picked
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Image.file(
                          state.imageFile,
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
                              myCubit.clearImage(); // Clear image state
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
                            onPressed: myCubit
                                .pickImage, // Use cubit's method to pick image
                            icon: Icon(Icons.attach_file, color: KprimaryColor),
                          ),
                          SizedBox(width: 5),
                          IconButton(
                            onPressed: () {
                              myCubit.sendMessage(myCubit.pickedImage,
                                  textController.text, email);
                              textController.clear();
                            },
                            icon: Icon(Icons.send, color: Colors.blue),
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
          },
        ));
  }
}
