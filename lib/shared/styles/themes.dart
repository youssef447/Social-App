import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_app/constants.dart';

ThemeData darkTheme = ThemeData(
  primarySwatch: defaultColor,
  scaffoldBackgroundColor: const Color(0Xff1c242f), // const Color(0XFF333739),
  appBarTheme: const AppBarTheme(
    titleSpacing: 20.0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Color(0XFF333739),
      statusBarIconBrightness: Brightness.light,
    ),
    backgroundColor:  Color(0XFF233040),
    elevation: 0.0,
    titleTextStyle: TextStyle(
      fontFamily: 'Jannah',
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color(0Xff1c242f),
  ),
  iconTheme: const IconThemeData(color: Colors.white),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Colors.deepOrange,
    unselectedItemColor: Colors.grey,
    elevation: 20.0,
    backgroundColor: Color(0xFF333739),
  ),
  dividerTheme: const DividerThemeData(thickness: 1.5, color: Colors.white),
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    /*   bodyText2: TextStyle(
      fontSize: 15.0,
      //fontWeight: FontWeight.w600,
      color: Colors.white,
    ), */
    subtitle1: TextStyle(
        fontSize: 14.0,
        // fontWeight: FontWeight.w600,
        color: Colors.white,
        fontWeight: FontWeight.normal
        //height: 1.3,
        ),
    subtitle2: TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
  ),
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Color(0XFF233040),
  ),
  fontFamily: 'Jannah',
  radioTheme: RadioThemeData(
    fillColor: MaterialStateProperty.all(defaultColor),
  ),
);

ThemeData lightTheme = ThemeData(
  
  scaffoldBackgroundColor: Colors.white,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
      //backgroundColor: defaultColor,

      ),
  dividerTheme: const DividerThemeData(
    thickness: 1.5,
    color: Color(0Xff1c242f),
  ),
  
  colorScheme: const ColorScheme.light(primary: defaultColor),
  appBarTheme: const AppBarTheme(
    titleSpacing: 20.0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      systemNavigationBarColor: defaultColor,
      statusBarIconBrightness: Brightness.dark,
    ),
    
    backgroundColor: Colors.white,
    elevation: 0.0,
    titleTextStyle: TextStyle(
      fontFamily: 'Jannah',
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: defaultColor,
    unselectedItemColor: Colors.grey,
    elevation: 20.0,
    backgroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      //height: .
    ),
    subtitle1: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    subtitle2: TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
  ),
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Colors.white,
  ),
  fontFamily: 'Jannah',
  radioTheme: RadioThemeData(
    fillColor: MaterialStateProperty.all(defaultColor),
  ),
);
