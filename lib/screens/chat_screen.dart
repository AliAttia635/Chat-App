import 'package:chatapp/constats/constant.dart';
import 'package:chatapp/models/message_model.dart';
import 'package:chatapp/widgets/ChatBubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatefulWidget {
  ChatPage({super.key});
  static String id = "ChatPage";

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController textController = TextEditingController();

  CollectionReference messages =
      FirebaseFirestore.instance.collection(KcollectionMessages);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: messages.get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<MessageModel> messagesList = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              // search 3la el 7eta deh {MessageModel.fromJson} ya3ny leh ba3melaha be tareka deh bdal ma aktb "snapshot.data!.docs[i]" 3la tol
              messagesList.add(MessageModel.fromJson(snapshot.data!.docs[i]));
            }
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      scholarImage,
                      height: 60,
                    ),
                    Text(
                      "Scholar Chat",
                      style: TextStyle(fontSize: 19),
                    ),
                  ],
                ),
                backgroundColor: KprimaryColor,
                centerTitle: true,
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: messagesList.length,
                        itemBuilder: (context, index) {
                          return CustomChatBubble(
                            message: messagesList[index],
                          );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: textController,
                      onSubmitted: (data) {
                        messages.add({
                          'text': data,
                        });
                        textController.clear();
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: "Send Message",
                        suffixIcon: Icon(
                          Icons.send,
                          color: KprimaryColor,
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
              ),
            );
          } else {
            return Text("loading....");
          }
        });
  }
}
