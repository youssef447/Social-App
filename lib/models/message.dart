import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  Timestamp _time = Timestamp.now();
  String? _text;
  String _senderId = "";
  String _recieverId = "";
  String get recieverId => _recieverId;

  String? _imgUrl;

  Timestamp get time => _time;

  String? get text => _text;

  String get senderId => _senderId;

  String? get imgUrl => _imgUrl;
  Message({
    required Timestamp time,
    String? text,
    String? imgUrl,
    required String senderId,
    required String recieverId
  }) {
    _time = time;
    _text = text;
    _senderId = senderId;
    _recieverId=recieverId;
    _imgUrl = imgUrl;
  }

  Message.fromJson(Map<String, dynamic> json) {
    _time = json['time'];
    _imgUrl = json['image url'];
    _text = json['text'];
    _senderId = json['sender id'];
    _recieverId = json['reciever id'];
  }

  toMap() {
    return {
      'time': time,
      'text': text,
      'image url': imgUrl,
      'sender id': senderId,
      'reciever id': recieverId
    };
  }
}
