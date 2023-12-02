
import 'CommentsModel.dart';

class Post {
  String? _text;
  String? get text => _text;

  String? _postIimageUrl;
  int numberOfPosts=0;
  List<String>_likes=[];
 List<String> get likes => _likes;

 setLikes(List<dynamic>val){
  _likes=val.cast<String>();
 }
 


  DateTime _now = DateTime.now();

  DateTime get now => _now;

  String? get postIimageUrl => _postIimageUrl;
  String _uID = "";
  String _postUID="";
  String get uID => _uID;

  String get postUID => _postUID;
  setPostUID(String val)=>_postUID=val; 
  int _TotalComments=0;

  int get TotalComments => _TotalComments;
  setTotalComments(int val)=>_TotalComments=val; 

  List<CommentsModel>_comments=[];

List<CommentsModel>get comments => _comments;
  setComments(List<CommentsModel> val)=>_comments=val; 

  Post(
      {
      required DateTime now,
      required String uID,
      String? text,
      String? postIimageUrl,
      List<CommentsModel>? commentModel,
     }) {
    _uID = uID;
    _text = text;
    _postIimageUrl = postIimageUrl;
    _now = now;
  }
  Post.fromJson(Map<String, dynamic> json) {
    _postIimageUrl = json['post image url'];
    _text = json['text'];
    _now = json['time'].toDate();
    _uID = json['uID'];
    _TotalComments=json['total comments'];
    _likes = json['likes'].cast<String>();

  }
  Map<String, dynamic> toMap() {
    return {
      'post image url': postIimageUrl,
      'text': text,
      'time': now,
      'uID': uID,
      'total comments':TotalComments,

      'likes':[],
    };
  }
}
