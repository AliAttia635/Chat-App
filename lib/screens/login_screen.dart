import 'package:chatapp/constats/constant.dart';
import 'package:chatapp/cubit/auth_cubit/auth_cubit.dart';
import 'package:chatapp/helpers/show_Snack_Bar.dart';
import 'package:chatapp/screens/Signup_screen.dart';
import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/widgets/Button.dart';
import 'package:chatapp/widgets/TextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatelessWidget {
  static String id = 'LoginPage';

  LoginPage({super.key});

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    String? email;

    String? password;
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LogInSuccess) {
          Navigator.pushNamed(context, ChatPage.id, arguments: email);
        } else if (state is LogInFailed) {
          if (state.errorMessage == 'user-not-found') {
            showSnackbar(context, 'No user found for that email.');
          } else if (state.errorMessage == 'wrong-password') {
            showSnackbar(context, 'Wrong password provided for that user.');
          } else {
            showSnackbar(context, "there was an error, please try again");
          }
        }
      },
      builder: (context, state) {
        if (state is LogInLoading) {
          return Scaffold(
            backgroundColor: KprimaryColor,
            appBar: AppBar(
              backgroundColor: KprimaryColor,
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          backgroundColor: KprimaryColor,
          appBar: AppBar(
            backgroundColor: KprimaryColor,
          ),
          body: Form(
            key: formKey,
            child: ListView(
              children: [
                const SizedBox(
                  height: 90,
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
                            "Sign in",
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
                              text: 'Sign In',
                              ontap: () async {
                                if (formKey.currentState!.validate()) {
                                  await BlocProvider.of<AuthCubit>(context)
                                      .login_User(context, email!, password!);
                                }
                              },
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "don\'t have an account?",
                              style: TextStyle(color: Colors.white),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  Navigator.pushNamed(context, SignUpPage.id),
                              child: const Text("   sign up",
                                  style: TextStyle(color: Colors.lightBlue)),
                            )
                          ],
                        )
                      ],
                    ))
              ],
            ),
          ),
        );
      },
    );
  }
}
