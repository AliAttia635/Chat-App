part of 'chat_cubit.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {}

class ChatImageSelected extends ChatState {
  final File imageFile;
  ChatImageSelected(this.imageFile);
}

class ChatImageCleared extends ChatState {}

class ChatFailed extends ChatState {}
