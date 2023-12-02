import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:social_app/Cubit/login/loginCubit.dart';
import 'package:social_app/Cubit/signup/signUpCubit.dart';
import 'package:social_app/Cubit/social/socialCubit.dart';
import 'package:social_app/Login.dart';
import 'package:social_app/Network/local/cach_helper.dart';
import 'package:social_app/models/Firebase.dart';
import 'package:geocoding/geocoding.dart';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import 'package:social_app/constants.dart';
import 'package:social_app/shared/styles/themes.dart';
import 'package:tbib_toast/tbib_toast.dart';

import 'package:location/location.dart' as loc;

import '../Home.dart';

naviagteTo(context, widget) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
    return widget;
  }));
}

naviagte(context, widget) {
  Navigator.push(context, MaterialPageRoute(builder: (_) {
    return widget;
  }));
}

Widget defaultFormField(
    {required contoller,
    required BuildContext context,
    bool isPassword = false,
    FocusNode? focusNode,
    TextInputType? type,
    bool? expand,
    String? helperText,
    Widget? label,
    bool readonly = false,
    bool filled = false,
    double radius = 0,
    IconData? prefix,
    IconData? suffix,
    Function()? onTap,
    Widget? prefixWidget,
    Widget? suffixWidget,
    String? labelText,
    bool? borderNone,
    String? Function(String?)? validate,
    Function(String)? onchanged,
    Function()? suffixPressed,
    String? hintText}) {
  return TextFormField(
    validator: validate,
    controller: contoller,
    
    obscureText: isPassword,
    keyboardType: type,
    readOnly: readonly,
    onTap: onTap,
    onChanged: onchanged,
    minLines: expand != null ? null : 1,
    maxLines: expand != null ? null : 1,
    expands: expand != null ? true : false,
    style:filled? Theme.of(context).textTheme.subtitle1!.copyWith(color:Colors.black):Theme.of(context).textTheme.subtitle1!,
    //onFieldSubmitted: ((value) => print(contoller.text)),
    focusNode: focusNode,
    
    decoration: InputDecoration(
      
      hintText: hintText,
      hintStyle: filled
          ? Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.black)
          : Theme.of(context).textTheme.subtitle1!,
      helperText: helperText,
      label: label,
      helperMaxLines: 2,
      
      
      

      labelStyle:
          Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.black),
      // focusColor: defaultColor,
      labelText: labelText,
      helperStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
            color: Colors.grey[400],
          )
          

      /*  focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),),
         errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),), */

      ,
      filled: filled,
      

      fillColor: Colors.grey[350],
      prefixIcon: prefixWidget,

      prefixIconColor: Theme.of(context).iconTheme.color,
    
      suffixIcon: suffixWidget,

      /* IconButton(
        onPressed: suffixPressed,
        icon: Icon(
          suffix,
          color: Colors.deepOrange,
        ),
      ), */
      //enabledBorder: InputBorder.,

      border: UnderlineInputBorder(
          borderSide: borderNone != null ? BorderSide.none : const BorderSide(),
          borderRadius: BorderRadius.circular(
            radius,
          )),
    ),
  );
}

void showToast(
    {required String message, required ToastStates state, required context}) {
  Toast.show(message, context,
      duration: Toast.lengthLong,
      backgroundColor: ToastColor(state),
      gravity: Toast.bottom);
}

enum ToastStates { error, wrong, right }

Color ToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.error:
      color = Colors.red;
      break;

    case ToastStates.wrong:
      color = Colors.amber;
      break;
    case ToastStates.right:
      color = Colors.deepOrange;
      break;
  }
  return color;
}

/* Future<File> getImageFileFromAssets(String path) async {
  final byteData = await rootBundle.load(path);
  final file = await File('${(await getTemporaryDirectory()).path}/$path')
      .create(recursive: true);
  await file.writeAsBytes(byteData.buffer
      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  return file;
} */

awesomeDialog(
    {required BuildContext context,
    required String text,
    required String title,
    required DialogType dialogType,
    Function()? onPressed}) {
  return AwesomeDialog(
          //dialogBackgroundColor: Colors.deepOrange,
          context: context,
          title: title,
          body: Text(text),
          dialogType: dialogType,
          btnOkOnPress: onPressed,
          btnOkColor:
              dialogType == DialogType.ERROR ? Colors.red : Colors.green)
      .show();
}

Widget defaultElevatedButton(
    {double elevation = 5,
    double? width,
    double? height,
    required String text,
    Color shadowColor = Colors.white,
    Color foregroundColor = Colors.white,
    Color backgroundColor = defaultColor,
    Function()? onPressed,
    double radius = 28.0}) {
  return ElevatedButton(
    style: ButtonStyle(
      elevation: MaterialStateProperty.all<double>(elevation),
      shadowColor: MaterialStateProperty.all<Color>(shadowColor),
      foregroundColor: MaterialStateProperty.all<Color>(foregroundColor),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          //side: BorderSide(color: Colors.red),
        ),
      ),
      minimumSize: width != null && height != null
          ? MaterialStateProperty.all(
              Size(width, height),
            )
          : null,
      // backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
    ),
    onPressed: onPressed,
    child: Text(
      text,
      style: const TextStyle(color: Colors.white),
    ),
  );
}

//Verification Screen
Widget verificationScreen(BuildContext context, String email, String pass) {
  var height = MediaQuery.of(context).size.height;
  var width = MediaQuery.of(context).size.width;
  // bool emailVerified=FirebaseAuth.instance.currentUser!.emailVerified;

  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      SizedBox(
        //  width: width * 0.5,
        height: height * 0.4,
        child: Image.asset('assets/email.png'),
      ),
      const Text('Please Verify Your Email'),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              firebase.verifyEmail().then(
                (value) {
                  awesomeDialog(
                      context: context,
                      text: "Please check your email",
                      title: "Email Verification sent",
                      dialogType: DialogType.SUCCES,
                      onPressed: () {
                        loginCubit.get(context).signIn(email, pass, context);
                      }).catchError((onError) {
                    awesomeDialog(
                        context: context,
                        text: onError.toString(),
                        title: "Something Went Wrong",
                        dialogType: DialogType.ERROR,
                        onPressed: () {});
                  });
                },
              );
            },
            child: Text(
              'send email verification',
              style:
                  lightTheme.textTheme.subtitle1!.copyWith(color: defaultColor),
            ),
          ),
          TextButton(
            onPressed: () {
              loginCubit.get(context).signIn(email, pass, context);
            },
            child: Text('skip', style: lightTheme.textTheme.caption),
          ),
        ],
      )
      /*  defaultElevatedButton(
               width: double.infinity,
               height: 50,
               text: "Send verification email",
               onPressed: () {
                 firebase.verifyEmail().then((value) {
                   awesomeDialog(
                       context: context,
                       text: "Please check your email",
                       title: "Email Verification sent",
                       dialogType: DialogType.SUCCES,
                       onPressed: () {});
                 }).catchError((onError) {
                   awesomeDialog(
                       context: context,
                       text: onError.toString(),
                       title: "Something Went Wrong",
                       dialogType: DialogType.ERROR,
                       onPressed: () {});
                 });
               }), */
    ],
  );
}

Widget profilePicWidget({
  signupCubit? signupCubit,
  socialCubit? socialCubit,
  Function()? onPressed,
  required bool signUpScreen,
  required bool editProfileScreen,
  String? profileUrl,
}) {
  return signUpScreen
      ? GestureDetector(
          onTap: onPressed,
          child: Stack(
            alignment: Alignment.bottomRight,
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 70,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 65,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: signupCubit!.profimgFile == null
                      ? const AssetImage('assets/person.png')
                      : FileImage(
                          signupCubit.profimgFile!,
                        ) as ImageProvider,
                ),
              ),
              GestureDetector(
                onTap: onPressed,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[400],
                  child: const FittedBox(
                      child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  )),
                ),
              ),
            ],
          ),
        )
      : editProfileScreen
          ? GestureDetector(
              onTap: onPressed,
              child: Stack(
                alignment: Alignment.bottomRight,
                clipBehavior: Clip.none,
                children: [
                  Hero(
                    tag: socialCubit!.user!.profileIimageUrl != null
                        ? 'networkprofile'
                        : 'assetprofile',
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 65,
                        backgroundColor: const Color.fromRGBO(224, 224, 224, 1),
                        backgroundImage: socialCubit.profimgFile != null
                            ? FileImage(
                                socialCubit.profimgFile!,
                              )
                            : socialCubit.user!.profileIimageUrl != null
                                ? NetworkImage(
                                        socialCubit.user!.profileIimageUrl!)
                                    as ImageProvider
                                : const AssetImage('assets/person.png'),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onPressed,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[400],
                      child: const FittedBox(
                          child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      )),
                    ),
                  ),
                ],
              ),
            )
          : GestureDetector(
              onTap: () {
                //نبقي نظهر الصورة
              },
              child: Hero(
                tag: profileUrl != null ? 'networkprofile' : 'assetprofile',
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 65,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: profileUrl != null
                        ? NetworkImage(profileUrl)
                        : const AssetImage('assets/person.png')
                            as ImageProvider,
                  ),
                ),
              ),
            );
}

Future<String> getAddress() async {
  var location = loc.Location();
  bool _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();

    if (!_serviceEnabled) {
      return "";
    }
  }
  //now i'm sure i got the service
  //check if app has permission to access location permission ..returns permission status
  var _permission = await location.hasPermission();
  if (_permission == PermissionStatus.denied) {
    _permission = await location.requestPermission();

    if (_permission != PermissionStatus.granted) {
      return "";
    }
  }
  print("tesst");

  //now i'm sure i got the permission
  //get location..returns LocationData object
  var currentLocation = await location.getLocation();
  List<Placemark> placemark = await placemarkFromCoordinates(
      currentLocation.latitude!, currentLocation.longitude!);
  String country = placemark[0].country!;
  print('countryyyyyyyyyyyyyyy  $country');
  String name = placemark[0].administrativeArea!.split(" ")[0];
  String street = placemark[0].street!;
  print(street + ",$name $country");
  return street + ",$name $country";
}

Widget sheetWidget(BuildContext context,
    {required bool profile,
    required bool signUpScreen,
    bool? video,
    bool?message,
    bool? post,bool?comment}) {
  // var cubit =   socialCubit.get(context);

  return Container(
    color: Theme.of(context).scaffoldBackgroundColor,
    height: MediaQuery.of(context).size.height * 0.1,
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Column(
        children: [
          Expanded(
            child: IconButton(
              onPressed: () {
                !signUpScreen
                    ? socialCubit.get(context).pickImage(
                        source: ImageSource.camera,
                        ctx: context,
                        profile: profile,
                        video: video,
                        message: message,
                        comment: comment,
                        post: post)
                    : signupCubit.get(context).pickImage(
                        source: ImageSource.camera,
                        ctx: context,
                        profile: profile,
                        video: video);
              },
              icon: Icon(
                Icons.camera_alt,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Camera',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ],
      ),
      Column(
        children: [
          Expanded(
            child: IconButton(
              onPressed: () {
                !signUpScreen
                    ? socialCubit.get(context).pickImage(
                        source: ImageSource.gallery,
                        ctx: context,
                        profile: profile,
                        message: message,
                        video: video,
                        comment: comment,
                        post: post)
                    : signupCubit.get(context).pickImage(
                        source: ImageSource.gallery,
                        ctx: context,
                        profile: profile,
                        video: video);
              },
              icon: Icon(
                Icons.photo_size_select_actual,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Gallery',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ],
      )
    ]),
  );
}

Logout(BuildContext context) {
  CacheHelper.removeData(key: "Token");
  naviagteTo(context, const Login());
}

deleteAccount({
  required BuildContext context,
  required String userId,
}) async {
  //DELETE COLLECTION
  CollectionReference usersref =
      FirebaseFirestore.instance.collection("employees");
  await usersref.doc(userId).delete();

  //DELETE PROFILE PICS
  await FirebaseStorage.instance.ref(userId).delete();

  //REMOVE
  await FirebaseAuth.instance.currentUser!.delete();
  awesomeDialog(
      context: context,
      text: 'Account Deletred',
      title: 'Account',
      dialogType: DialogType.INFO);
}
