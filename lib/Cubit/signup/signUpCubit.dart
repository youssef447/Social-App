import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/models/Firebase.dart';

import '../../models/user.dart';
import '../../shared/components.dart';
import 'signupStates.dart';

class signupCubit extends Cubit<signupStates> {
  signupCubit() : super(signupInitialState());

  static signupCubit get(ctx) => BlocProvider.of(ctx);
  bool signupLoading = false;
  bool visiblePassword = false;
  String? profileImageUrl;
  String? coverimgUrl;

  File? profimgFile;
  File? coverimgFile;

  /* toggleLoading(){
     loading=true;

   } */
  int currentStep = 0;
  forwardCurrentStep() {
    currentStep += 1;
    emit(updatedCurrentStep());
  }

  backCurrentStep() {
    currentStep -= 1;
    emit(updatedCurrentStep());
  }

  setTappedStep(int index) {
    currentStep = index;
    emit(updatedCurrentStep());
  }

  void signUp({
    required String email,
    String? bio,
    String? location,
    required String username,
    required String pass,
    required String phone,
    required BuildContext ctx,
  }) {
    signupLoading = true;
    emit(signupLoadingState());

    firebase.registerUser(email, pass).then((value) async {
      final storageRef = FirebaseStorage.instance.ref();

      if (profimgFile != null) {
        await storageRef
            .child(value.user!.uid)
            .child("profile")
            .putFile(profimgFile!);

        profileImageUrl = await storageRef
            .child(value.user!.uid)
            .child("profile")
            .getDownloadURL();
      }
      if (coverimgFile != null) {
        await storageRef
            .child(value.user!.uid)
            .child("cover")
            .putFile(coverimgFile!);
           
          coverimgUrl = await storageRef
              .child(value.user!.uid)
              .child("cover")
              .getDownloadURL();
        
      }
      User user = User(
          email: email,
          bio: '',
          location: location??'',
          coverImageUrl: coverimgUrl??'',
          username: username,
          profileIimageUrl: profileImageUrl??'',
          phone: phone,
          Token: value.user!.uid);
      addUser(user, ctx);

  
    }).catchError((onError) {
      signupLoading = false;
      showToast(
          message: onError.toString(), state: ToastStates.error, context: ctx);

      emit(signupErrorState(onError));
    });
  }

  void addUser(
    User user,
    BuildContext ctx,
  ) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.getToken.toString())
        .set(user.toMap())
        .then((value) {
     
      awesomeDialog(
          context: ctx,
          text: "Registered Successfully",
          title: "Sign up",
          dialogType: DialogType.SUCCES,
          onPressed: () {});
      signupLoading = false;
      forwardCurrentStep();
      emit(signupSuccessState());
    }).catchError((onError) {
      signupLoading = false;
      showToast(
          message: onError.toString(), state: ToastStates.error, context: ctx);

      emit(signupErrorState(onError));
    });
  }

  pickImage({required ImageSource source,required BuildContext ctx,required bool profile,bool?video}) async {
    final ImagePicker _picker = ImagePicker();

    XFile? image =
        await _picker.pickImage(source: source,imageQuality: 85).catchError((onError) {
      emit(pickedImageErrorState(onError.toString()));
    });

    if (profile && image != null) {
      profimgFile = File(image.path,);
      emit(pickedImageSuccessState());
    } else if (!profile && image != null) {
      coverimgFile = File(image.path);
      emit(pickedImageSuccessState());
    }

    Navigator.of(ctx).pop();
  }
}
