import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chatapp/helpers/show_Snack_Bar.dart';
import 'package:chatapp/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> login_User(
      BuildContext context, String email, String password) async {
    var auth = FirebaseAuth.instance;
    try {
      UserCredential user = await auth.signInWithEmailAndPassword(
          email: email!, password: password!);
      emit(LogInSuccess());
      Navigator.pushNamed(context, ChatPage.id, arguments: email);
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'user-not-found') {
        showSnackbar(context, 'No user found for that email.');
        emit(LogInFailed());
      } else if (ex.code == 'wrong-password') {
        showSnackbar(context, 'Wrong password provided for that user.');
        emit(LogInFailed());
      } else {
        emit(LogInFailed());
        showSnackbar(context, "there was an error, please try again");
      }
    } catch (e) {
      log(e.toString());
      showSnackbar(context, "there was an error");
      emit(LogInFailed());
    }
  }

  Future<void> register_user(
      BuildContext context, String email, String password) async {
    var auth = FirebaseAuth.instance;
    try {
      UserCredential user = await auth.createUserWithEmailAndPassword(
          email: email!, password: password!);
      emit(SignUpSuccess());
      Navigator.pushNamed(context, ChatPage.id, arguments: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackbar(context, 'The password provided is too weak.');
        emit(SignUpFailed());
      } else if (e.code == 'email-already-in-use') {
        showSnackbar(context, 'The account already exists for that email.');
        emit(SignUpFailed());
      }
    } catch (e) {
      showSnackbar(context, "there was an error");
      emit(SignUpFailed());
    }
  }
}
