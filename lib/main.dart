import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:social_app/Cubit/signup/signUpCubit.dart';
import 'package:social_app/Cubit/social/socialCubit.dart';
import 'package:social_app/Cubit/social/socialStates.dart';
import 'package:social_app/Home.dart';
import 'package:social_app/Login.dart';
import 'package:social_app/shared/styles/themes.dart';

import 'Cubit/login/loginCubit.dart';
import 'Network/local/cach_helper.dart';
import 'Onboard.dart';
import 'package:social_app/models/Firebase.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await firebase.initalize();
  bool isDark=CacheHelper.getData(key: 'isDark')??false;

  Widget widget;

  bool skipped = CacheHelper.getData(key: "skipped") ?? false;
  if (skipped) {
    bool Token = CacheHelper.getData(key: "Token") == null ? false : true;
    if (Token) {
      /*  if (FirebaseAuth.instance.currentUser!.emailVerified) {
        
      } else {
        widget =  const Login();
      } */
      uID = CacheHelper.getData(key: "Token");
      widget = Home();
    } else {
      widget = const Login();
    }
  } else {
    widget = const Onboard();
  }

  runApp(MyApp(
    layout: widget,
    isDark: isDark,
    
  ));
}

class MyApp extends StatelessWidget {
  Widget layout;
   final bool isDark;

  MyApp({Key? key, required this.layout,required this.isDark}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      child: BlocConsumer<socialCubit, socialStates>(
        listener: (context, state) {},
        builder: ((context, state) {
          print(state);

         var cubit = socialCubit.get(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Social App',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: cubit.isDark ? ThemeMode.dark : ThemeMode.light,
            home: layout,
          );
        }),
      ),
      providers: [
        BlocProvider(
          create: (context) => loginCubit(),
        ),
        BlocProvider(
          create: (context) => signupCubit(),
        ),
        BlocProvider(
          create: (context) => socialCubit()..switchThemeMode(fromShared:isDark),
        ),
      ],
    );
  }
}
