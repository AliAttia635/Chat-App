part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class LogInInitial extends AuthState {}

class LogInSuccess extends AuthState {}

class LogInLoading extends AuthState {}

class LogInFailed extends AuthState {
  String errorMessage;
  LogInFailed({required this.errorMessage});
}

class SignUpInitial extends AuthState {}

class SignUpSuccess extends AuthState {}

class SignUpLoading extends AuthState {}

class SignUpFailed extends AuthState {
  String errorMessage;
  SignUpFailed({required this.errorMessage});
}
