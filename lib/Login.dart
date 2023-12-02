import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:social_app/Cubit/login/loginStates.dart';
import 'package:social_app/Signup.dart';
import 'package:social_app/shared/components.dart';

import 'Cubit/login/loginCubit.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  @override
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      /*  appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ), */
      body: BlocConsumer<loginCubit, loginStates>(
        listener: (context, state) {},
        builder: ((context, state) => SafeArea(
              child: SingleChildScrollView(
                child: Stack(
                  alignment: Alignment.topLeft,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: 3.0.h, left: 5.w, right: 5.w, bottom: 5.w),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              width: 50.w,
                              height: 34.h,
                              child: Image.asset('assets/login.png'),
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                    style: ButtonStyle(
                                      elevation:
                                          MaterialStateProperty.all<double>(5),
                                      shadowColor:
                                          MaterialStateProperty.all<Color>(
                                        const Color.fromARGB(
                                            255, 255, 255, 255),
                                      ),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(28.0),
                                          //side: BorderSide(color: Colors.red),
                                        ),
                                      ),
                                      fixedSize: MaterialStateProperty.all(
                                          //Size(width*0.3, height*0.08)),
                                          Size(30.w, 5.h)),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        const Color.fromARGB(
                                            255, 255, 255, 255),
                                      ),
                                    ),
                                    onPressed: null,
                                    child: Image.asset('assets/google.png')),
                                ElevatedButton(
                                    style: ButtonStyle(
                                      elevation:
                                          MaterialStateProperty.all<double>(5),
                                      shadowColor:
                                          MaterialStateProperty.all<Color>(
                                        const Color(0XFF1877f2),
                                      ),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(28.0),
                                          //side: BorderSide(color: Colors.red),
                                        ),
                                      ),
                                      fixedSize: MaterialStateProperty.all(
                                          // Size(MediaQuery.of(context).size.width*0.3, 5.h)),
                                          Size(30.w, 5.h)),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        const Color(0XFF1877f2),
                                      ),
                                    ),
                                    onPressed: null,
                                    child: Image.asset('assets/facebook.png')),
                              ],
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Divider(
                                  indent: 2.w,
                                  thickness: 0.2.h,
                                )),
                                const Text(' OR '),
                                Expanded(
                                    child: Divider(
                                  endIndent: 2.w,
                                  thickness: 0.2.h,
                                ))
                              ],
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            defaultFormField(
                                context: context,
                                
                                prefixWidget: const Icon(Icons.email_outlined),
                                contoller: emailcontroller,
                                hintText: "Email Address",
                                filled: true,
                                validate: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'please enter your email';
                                  }
                                  return null;
                                },
                                type: TextInputType.emailAddress),
                            SizedBox(
                              height: 2.h,
                            ),
                            defaultFormField(
                                context: context,
                                prefixWidget: const Icon(Icons.lock),
                                contoller: passcontroller,
                                hintText: "Password",
                                isPassword: true,
                                validate: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'please enter your password';
                                  }
                                  return null;
                                },
                                filled: true),
                            Row(
                              children: const [
                                Spacer(),
                                TextButton(
                                    onPressed: null,
                                    child: Text(
                                      'forgot password?',
                                      style:
                                          TextStyle(color: Colors.deepOrange),
                                    ))
                              ],
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            loginCubit.get(context).loadingLogin
                                ? const CircularProgressIndicator(
                                    color: Colors.deepOrange,
                                  )
                                : ElevatedButton(
                                    style: ButtonStyle(
                                      elevation:
                                          MaterialStateProperty.all<double>(5),
                                      shadowColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.deepOrange),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(28.0),
                                          //side: BorderSide(color: Colors.red),
                                        ),
                                      ),
                                      minimumSize: MaterialStateProperty.all(
                                          Size(double.infinity, 7.h)),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.deepOrange),
                                    ),
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        formKey.currentState!.save();
                                        loginCubit.get(context).signIn(
                                            emailcontroller.text,
                                            passcontroller.text,
                                            context);
                                      }
                                    },
                                    child: const Text('Login'),
                                  ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('not registered?'),
                                TextButton(
                                    onPressed: () =>
                                        naviagte(context, Signup()),
                                    child: const Text(
                                      'create Account',
                                      style:
                                          TextStyle(color: Colors.deepOrange),
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0.h),
                      child: Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
