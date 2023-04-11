import 'dart:core';

class MessageModel {
  final String text;
  final bool isUser;

  MessageModel({required this.text, required this.isUser});
}

class MessageModelOpenAI {
  String role;
  String content;

  MessageModelOpenAI({required this.role, required this.content});

  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'content': content,
    };
  }

  factory MessageModelOpenAI.fromMap(Map<String, dynamic> map) {
    return MessageModelOpenAI(
      role: map['role'],
      content: map['content'],
    );
  }
}
