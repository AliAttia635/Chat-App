import 'package:chatapp/constats/constant.dart';
import 'package:chatapp/cubit/auth_cubit/auth_cubit.dart';
import 'package:chatapp/helpers/show_Snack_Bar.dart';
import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/widgets/Button.dart';
import 'package:chatapp/widgets/TextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});
  static String id = 'signupPage';

  String? email;

  String? password;

  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is SignUpFailed) {
          if (state.errorMessage == 'weak-password') {
            showSnackbar(context, 'The password provided is too weak.');
          } else if (state.errorMessage == 'email-already-in-use') {
            showSnackbar(context, 'The account already exists for that email.');
          } else {
            showSnackbar(context, "there was an error, please try again");
          }
        } else if (state is SignUpSuccess) {
          Navigator.pushNamed(context, ChatPage.id, arguments: email);
        }
      },
      child: ModalProgressHUD(
        inAsyncCall: false,
        child: Scaffold(
          backgroundColor: Color(0xff2b475E),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: KprimaryColor,
          ),
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
                    "Quick Chat",
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
                            },
                            isPassword: false,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(6.0),
                          child: CustomFormTextField(
                            hint: "Password",
                            onChange: (data) {
                              password = data;
                            },
                            isPassword: true,
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: CustomButton(
                              text: "Sign Up",
                              ontap: () async {
                                if (formKey.currentState!.validate()) {
                                  await BlocProvider.of<AuthCubit>(context)
                                      .register_user(email!, password!);
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
      ),
    );
  }

  Future<void> register_user(BuildContext context) async {
    var auth = FirebaseAuth.instance;
    UserCredential user = await auth.createUserWithEmailAndPassword(
        email: email!, password: password!);
  }
}
