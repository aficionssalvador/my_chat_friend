import 'package:flutter/material.dart';
import 'package:my_chat_friend/models/config_model.dart';
import '/providers/config_provider.dart';
import '/providers/parameters_provider.dart';
import '/models/message_model.dart';

class MessagesProvider with ChangeNotifier {
  List<MessageModel> _messages = [];

  List<MessageModel> get messages => _messages;

  void addMessage(String text, bool isUser) {
    _messages.add(MessageModel(text: text, isUser: isUser));
    notifyListeners();
  }

  void addMessageNoListener(String text, bool isUser) {
    _messages.add(MessageModel(text: text, isUser: isUser));
    //notifyListeners();
  }
  void clearMessages(String text) {
    _messages.clear();
    _messages.add(MessageModel(text: text, isUser: false));
  }

  MessagesProvider() {
    //
  }
}

