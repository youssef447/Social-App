import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/Home.dart';
import 'package:social_app/constants.dart';
import 'package:social_app/models/Firebase.dart';

import '../../Network/local/cach_helper.dart';
import '../../shared/components.dart';
import 'loginStates.dart';

class loginCubit extends Cubit<loginStates> {
  loginCubit() : super(LoginInitialState());
  static loginCubit get(ctx) => BlocProvider.of(ctx);
  bool loadingLogin = false;
  void signIn(
    String email,
    String pass,
    BuildContext ctx,
  ) {
    loadingLogin = true;
    emit(LoginLoadingState());
    firebase
        .signInEmailPass(
      email,
      pass,
    )
        .then((value) async {
      loadingLogin = false;
      showToast(
          message: "Welcome " + value.user!.email!,
          state: ToastStates.right,
          context: ctx);
      await CacheHelper.saveData(key: 'Token', value: value.user!.uid);

      uID = value.user!.uid;

      naviagteTo(
        ctx,
        Home(),
      );

      emit(LoginSuccessState());
      //  print(value.user.email + " " + value.user.emailVerified.toString());
    }).catchError((onError) {
      print('hhhhhhhhhhhhhhhhhhhhhhhhhhhhhh');
      loadingLogin = false;
      showToast(
          message: onError.toString(), state: ToastStates.error, context: ctx);
      emit(LoginErrorState(onError.toString()));
    });
  }
}
