import 'dart:developer';
import 'dart:io';

import 'package:chatapp/constats/constant.dart';
import 'package:chatapp/models/message_model.dart';
import 'package:chatapp/widgets/ChatBubble.dart';
import 'package:chatapp/widgets/ChatBubbleForFirend.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

    // Add a listener to the textController to monitor changes
    textController.addListener(() {
      setState(() {
        // Enable/Disable button based on the text input and image status
        isButtonDisabled = textController.text.isEmpty &&
            imageUrl.isEmpty &&
            _pickedFile == null;
      });
    });
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
    return StreamBuilder<QuerySnapshot>(
        stream: messages.orderBy(KcreatedAt, descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<MessageModel> messagesList = snapshot.data!.docs
                .map((doc) => MessageModel.fromJson(doc))
                .toList();

            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(scholarImage, height: 60),
                    Text("Chat",
                        style: TextStyle(fontSize: 19, color: Colors.white)),
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
                                messageModel: messagesList[index])
                            : ChatBubbleForFriend(
                                messageModel: messagesList[index]);
                      },
                    ),
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
                                  _pickedFile =
                                      null; // Remove the image preview
                                  isButtonDisabled =
                                      textController.text.isEmpty;
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
                        _controller.animateTo(
                          0,
                          duration: Duration(seconds: 2),
                          curve: Curves.fastOutSlowIn,
                        );
                      },
                      decoration: InputDecoration(
                        hintText: "Send Message",
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: pickImage,
                              icon:
                                  Icon(Icons.attach_file, color: KprimaryColor),
                            ),
                            SizedBox(width: 5),
                            IconButton(
                              onPressed: isButtonDisabled
                                  ? null
                                  : () async {
                                      // If an image is selected, upload it now
                                      if (_pickedFile != null) {
                                        String uniqueImageFileName =
                                            DateTime.now()
                                                .microsecondsSinceEpoch
                                                .toString();
                                        Reference referenceRoot =
                                            FirebaseStorage.instance.ref();
                                        Reference referenceDirImages =
                                            referenceRoot.child('images');
                                        Reference referenceImageToUpload =
                                            referenceDirImages
                                                .child(uniqueImageFileName);

                                        await referenceImageToUpload
                                            .putFile(_pickedFile!);
                                        imageUrl = await referenceImageToUpload
                                            .getDownloadURL();
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
                                      setState(() {
                                        _pickedFile = null;
                                        imageUrl = ''; // Reset the image URL
                                        isButtonDisabled =
                                            true; // Disable the button again
                                      });
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
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: Text("loading....", style: TextStyle(fontSize: 24)),
              ),
            );
          }
        });
  }
}
