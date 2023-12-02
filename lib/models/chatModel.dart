import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  late String _recieverId;
  late Timestamp _time;
  late String _lastMessage;

  String get recieverId => _recieverId;

  Timestamp get time => _time;

  String get lastMessage => _lastMessage;

  ChatModel(
      {required String recieverId,
      required Timestamp time,
      required String lastMessage}) {
    _lastMessage = lastMessage;
    _time = time;
    _recieverId = recieverId;
  }

  ChatModel.fromJson(Map<String, dynamic> json) {
    _lastMessage = json['last message'];
    _time = json['time'];

    _recieverId = json['reciever id'];
  }
  toMap() {
    return {
      'last message': lastMessage,
      'time': time,
      'reciever id': recieverId,
    };
  }
}
