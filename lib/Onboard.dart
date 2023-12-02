import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:social_app/Home.dart';
import 'package:social_app/Network/local/cach_helper.dart';
import 'package:social_app/constants.dart';
import 'package:social_app/shared/components.dart';

import 'Login.dart';
import 'onBoardbiulder.dart';

class Onboard extends StatefulWidget {
  const Onboard({Key? key}) : super(key: key);

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  bool lastBoard = false;
  var pagecontroller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                skipBoarding();
              },
              child: const Text('Skip'))
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: PageView.builder(
                  controller: pagecontroller,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (ctx, index) {
                    return onBoardbiulder(onboard[index], context);
                  },
                  itemCount: onboard.length,
                  onPageChanged: (index) {
                    if (index == onboard.length - 1) {
                      lastBoard = true;
                    } else {
                      lastBoard = false;
                    }
                  },
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          pagecontroller.previousPage(
                              duration: const Duration(milliseconds: 700),
                              curve: Curves.linearToEaseOut);
                        },
                        icon: const Icon(Icons.arrow_back_ios_new)),
                    const Spacer(),
                    SmoothPageIndicator(
                      controller: pagecontroller,
                      count: onboard.length,
                      effect: ExpandingDotsEffect(
                        spacing: 15, //المساحة بينهم
                        dotHeight: 12, // كل ما يزيد هياخد شكل مستطيل كدا
                        activeDotColor: Theme.of(context).primaryColor,
                        dotWidth: 12, // كل ما يزيد هياخد شكل مستطيل كدا
                      ),
                    ),
                    const Spacer(),
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.orange,
                      child: IconButton(
                          onPressed: () {
                            if (lastBoard) {
                              skipBoarding();
                            } else {
                              pagecontroller.nextPage(
                                  duration: const Duration(milliseconds: 700),
                                  curve: Curves.linearToEaseOut);
                            }
                          },
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void skipBoarding() async {
    await CacheHelper.saveData(key: 'skipped', value: true);
    naviagteTo(context, const Login());
  }
}
