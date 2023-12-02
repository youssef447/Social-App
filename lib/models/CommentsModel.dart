import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsModel {
  String? _comment;
  String? _commentUid;

  setCommentUid(String value) {
    _commentUid = value;
  }

  String? get commentUid => _commentUid;

  String? _commentIimageUrl;

List<String> _likes=[];
List<String> get likes => _likes;

  Timestamp _now = Timestamp.now();

  String _uID = "";
  String? get comment => _comment;
  Timestamp get now => _now;
  String get uID => _uID;
  List<CommentsModel>_replies=[];
 List<CommentsModel> get replies => _replies;


  setReplies(List<CommentsModel> value) {
    _replies = value;
  }
  String? get commentIimageUrl => _commentIimageUrl;

  CommentsModel(
      {required String username,
      required Timestamp now,
      required String uID,
      String? comment,
            String? commentUid,

      String? commentIimageUrl,
      required String profileImageUrl}) {
    _uID = uID;
    _commentIimageUrl = commentIimageUrl;
    _comment = comment;
    _commentUid=commentUid??'';
    _now = now;
    _likes=[];
    
  }

  CommentsModel.fromJson(Map<String, dynamic> json) {
    
    _commentIimageUrl = json['comment image url'];
    _comment = json['comment'];
    _now = json['time'];
    _uID = json['uID'];
    _likes = json['likes'].cast<String>();
      }
  Map<String, dynamic> toMap() {
    return {
      'comment image url': commentIimageUrl,
      'comment': comment,
      'time': now,
      'uID': uID,
      'likes': likes,
    };
  }
}
