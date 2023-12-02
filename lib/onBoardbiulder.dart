import 'package:flutter/material.dart';
import 'package:social_app/models/welcomeScreenModule.dart';

Widget onBoardbiulder(welcomeScreenModule obj, context) {
  return Column(
    //crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
        child: Image.asset(
          '${obj.image}',
        ),
      ),
      Text(
        '${obj.title}',
                

        style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor),
      ),
      const SizedBox(
        height: 10,
      ),
      Text(
        '${obj.body}',
        textAlign: TextAlign.center,
        style: TextStyle(
          
            fontSize: 14,
            color: Theme.of(context).primaryColor),
      ),
    ],
  );
}
