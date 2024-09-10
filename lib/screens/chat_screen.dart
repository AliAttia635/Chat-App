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
        isButtonDisabled = textController.text.isEmpty && imageUrl.isEmpty;
      });
    });
  }

  void pickImage() async {
    try {
      XFile? pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      String uniqueImageFileName =
          DateTime.now().microsecondsSinceEpoch.toString();

      //step 2 : upload to firebase storage
      // get a refrence to storage root
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('images');

      //create a refrence for the image to be stored
      Reference referenceImageToUpload =
          referenceDirImages.child(uniqueImageFileName);

      // store the file
      await referenceImageToUpload.putFile(File(pickedFile.path));

      // success: get the download URL
      imageUrl = await referenceImageToUpload.getDownloadURL();

      // Update the button state after picking an image
      setState(() {
        isButtonDisabled = textController.text.isEmpty && imageUrl.isEmpty;
      });
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
                    Image.asset(scholarImage, height: 60),
                    Text("Scholar Chat", style: TextStyle(fontSize: 19)),
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
                            Icon(Icons.mic, color: KprimaryColor),
                            SizedBox(width: 5),
                            IconButton(
                              onPressed: pickImage,
                              icon:
                                  Icon(Icons.attach_file, color: KprimaryColor),
                            ),
                            SizedBox(width: 5),
                            IconButton(
                              onPressed: isButtonDisabled
                                  ? null
                                  : () {
                                      messages.add({
                                        Kmessage: textController.text,
                                        KcreatedAt: DateTime.now(),
                                        'id': email,
                                        KImageUrl: imageUrl,
                                      });
                                      textController.clear();
                                      setState(() {
                                        imageUrl =
                                            ''; // Reset the imageUrl after sending the message
                                        isButtonDisabled =
                                            true; // Disable the button again
                                      });
                                    },
                              icon: Icon(Icons.send),
                              color: const Color.fromARGB(255, 0, 104, 189),
                            ),
                            SizedBox(width: 5),
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
