class User {
  String _email = "";
  String _username = "";
  String? _phone;
  String? _profileIimageUrl;
  String? _bio;
  String? _location;
  String? get getLocation => _location;
  List<String> _followers = [];
  List<String> _following = [];
  
  List<String> get followers => _followers;
  int _numberOfPosts = 0;
  int get numberOfPosts => _numberOfPosts;

  setNumberOfPosts(int value) => _numberOfPosts = value;

   setFollowers(List<String> value) => _followers = value;

  List<String> get following => _following;

   setFollowing(List<String> value) => _following = value;

  String? get bio => _bio;

  String? _coverImageUrl;
  String? get coverImageUrl => _coverImageUrl;

  String _Token = "";

  String get getToken => _Token;

  String get email => _email;

  String get username => _username;

  String? get phone => _phone;

  String? get profileIimageUrl => _profileIimageUrl;

  User({
    required String email,
    String? bio,
    required String username,
    String? profileIimageUrl,
    String? coverImageUrl,
    String? phone,
    required String Token,
    String? location,
  }) {
    _email = email;
    _bio = bio;
    _location = location;
    _username = username;
    _phone = phone;
    _profileIimageUrl = profileIimageUrl;
    _coverImageUrl = coverImageUrl;

    _Token = Token;
  }
  User.fromJson(Map<String, dynamic> json) {
    _email = json['email'];
    _username = json['username'];
    _phone = json['phone'];
    _bio = json['bio'];
    _followers = json['followers'].cast<String>();
    _following = json['following'].cast<String>();
    _numberOfPosts = json['number of posts'];
    _profileIimageUrl = json['profile image url'];
    _coverImageUrl = json['cover image url'];

    _Token = json['token'];
    _location = json['location'];
  }
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'bio': bio,
      'phone': phone,
      'location': getLocation,
      'profile image url': profileIimageUrl,
      'cover image url': coverImageUrl,
      'token': getToken,
      'followers': [],
      'following': [],
      'number of posts': 0,
    };
  }
}
