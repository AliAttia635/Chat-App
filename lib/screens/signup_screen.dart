import 'package:chatapp/constats/constant.dart';
import 'package:chatapp/helpers/show_Snack_Bar.dart';
import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/widgets/Button.dart';
import 'package:chatapp/widgets/TextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});
  static String id = 'signupPage';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String? email;

  String? password;

  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: Color(0xff2b475E),
        appBar: AppBar(),
        body: Form(
          key: formKey,
          child: ListView(
            children: [
              const SizedBox(
                height: 100,
              ),
              Image.asset(
                scholarImage,
                height: 100,
              ),
              const Center(
                child: Text(
                  "Scholar Chat",
                  style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontFamily: 'Pacifico'),
                ),
              ),
              const SizedBox(
                height: 120,
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 6),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Sign Up",
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(6.0),
                        child: CustomFormTextField(
                            hint: "Email",
                            onChange: (data) {
                              email = data;
                            }),
                      ),
                      Padding(
                        padding: EdgeInsets.all(6.0),
                        child: CustomFormTextField(
                          hint: "Password",
                          onChange: (data) {
                            password = data;
                          },
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: CustomButton(
                            text: "Sign Up",
                            ontap: () async {
                              if (formKey.currentState!.validate()) {
                                try {
                                  isLoading = true;
                                  setState(() {});
                                  await register_user(context);
                                  Navigator.pushNamed(context, ChatPage.id);
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'weak-password') {
                                    showSnackbar(context,
                                        'The password provided is too weak.');
                                  } else if (e.code == 'email-already-in-use') {
                                    showSnackbar(context,
                                        'The account already exists for that email.');
                                  }
                                } catch (e) {
                                  showSnackbar(context, "there was an error");
                                }
                                isLoading = false;
                                setState(() {});
                              }
                            },
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: TextStyle(color: Colors.white),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text("   Log in",
                                style: TextStyle(color: Colors.lightBlue)),
                          )
                        ],
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> register_user(BuildContext context) async {
    var auth = FirebaseAuth.instance;
    UserCredential user = await auth.createUserWithEmailAndPassword(
        email: email!, password: password!);
  }
}
