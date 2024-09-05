import 'package:chatapp/constats/constant.dart';
import 'package:chatapp/models/message_model.dart';
import 'package:chatapp/widgets/ChatBubble.dart';
import 'package:chatapp/widgets/ChatBubbleForFirend.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});
  static String id = "ChatPage";

  final _controller = ScrollController();

  TextEditingController textController = TextEditingController();
  CollectionReference messages =
      FirebaseFirestore.instance.collection(KcollectionMessages);

  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder<QuerySnapshot>(
        stream: messages.orderBy(KcreatedAt, descending: true).snapshots(),
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
                        reverse: true,
                        controller: _controller,
                        itemCount: messagesList.length,
                        itemBuilder: (context, index) {
                          return messagesList[index].id == email
                              ? CustomChatBubble(
                                  messageModel: messagesList[index],
                                )
                              : ChatBubbleForFriend(
                                  messageModel: messagesList[index]);
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: textController,
                      onSubmitted: (data) {
                        messages.add({
                          Kmessage: data,
                          KcreatedAt: DateTime.now(),
                          'id': email,
                        });
                        textController.clear();
                        _controller.animateTo(
                          0,
                          duration: Duration(seconds: 2),
                          curve: Curves.fastOutSlowIn,
                        );
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
