

import 'package:flutter/material.dart';

import 'models/welcomeScreenModule.dart';

final List<welcomeScreenModule> onboard = [
  welcomeScreenModule(image: 'assets/message.png', title: 'Do real time messaging', body: 'Passing of any information on any screen, any device instantly is made simple at it\'s sublime'),
  welcomeScreenModule(image: 'assets/pv.png', title: 'Send photos and videos', body: 'Easily pick any photo or video to share with others'),
  welcomeScreenModule(image: 'assets/voice.png', title: 'Try voice messaging', body: 'Easily use your voice to simplify the conversation'),
];
  var emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
String uID="";
//appbarHeight+StatusbarHeight
double? height ;
double?width;
double?bottomMobileBarHeight;
double topPadding=0;
const MaterialColor defaultColor=Colors.deepOrange;