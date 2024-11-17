part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class LogInSuccess extends AuthState {}

class LogInFailed extends AuthState {}

class SignUpSuccess extends AuthState {}

class SignUpFailed extends AuthState {}
