import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chatapp/helpers/show_Snack_Bar.dart';
import 'package:chatapp/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(LogInInitial());

  Future<void> login_User(
      BuildContext context, String email, String password) async {
    var auth = FirebaseAuth.instance;
    emit(LogInLoading());
    try {
      UserCredential user = await auth.signInWithEmailAndPassword(
          email: email!, password: password!);
      emit(LogInSuccess());
    } on FirebaseAuthException catch (ex) {
      emit(LogInFailed(errorMessage: ex.code));
    } catch (e) {
      log(e.toString());
      emit(LogInFailed(errorMessage: e.toString()));
    }
  }

  Future<void> register_user(
      BuildContext context, String email, String password) async {
    var auth = FirebaseAuth.instance;
    emit(SignUpLoading());
    try {
      UserCredential user = await auth.createUserWithEmailAndPassword(
          email: email!, password: password!);
      emit(SignUpSuccess());
      Navigator.pushNamed(context, ChatPage.id, arguments: email);
    } on FirebaseAuthException catch (ex) {
      emit(SignUpFailed(errorMessage: ex.code));
    } catch (e) {
      emit(SignUpFailed(errorMessage: e.toString()));
    }
  }
}
