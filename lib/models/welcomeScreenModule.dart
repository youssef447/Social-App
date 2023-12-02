class welcomeScreenModule {
  String? _title;
  String? _body;
  String? _image;
  String? get title => _title;


  String? get body => _body;


  String? get image => _image;


  welcomeScreenModule({required String title, required String body, required String image}) {
    title;
    _body = body;
    _image = image;
    _title=title;
  }
}
