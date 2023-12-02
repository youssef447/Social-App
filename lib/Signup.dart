import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/Cubit/signup/signUpCubit.dart';
import 'package:social_app/Cubit/signup/signupStates.dart';
import 'package:social_app/myStepper.dart';
import 'package:social_app/shared/components.dart';

import 'constants.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  TextEditingController locationController = TextEditingController();

  TextEditingController bioController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  double? h;
  double? w;
 


  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[100],
      body: BlocConsumer<signupCubit, signupStates>(
        listener: (context, state) {},
        builder: ((context, state) {
          var cubit = signupCubit.get(context);

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: myCustomStepper(
                  steps: getSteps(cubit),
                  currentIndex: cubit.currentStep,
                  onForwardStep: () {
                    cubit.forwardCurrentStep();
                  },
                  onBackStep: () {
                    cubit.backCurrentStep();
                  },
                  isLast: cubit.currentStep == getSteps(cubit).length - 1),
            ),
          );

          /*  MediaQuery.of(context).orientation == Orientation.portrait
                  ? portraitMode()
                  : landscapeMode(), */
        }),
      ),
    );
  }

  List<Steps> getSteps(signupCubit cubit) {
    return [
      Steps(
          title: "account setup",
          icon: Icons.info_outline,
          completed: cubit.currentStep > 0,
          onTapped: () {
            if (cubit.currentStep != 2) cubit.setTappedStep(0);
          },
          content: portraitMode(formKey),
          isActive: cubit.currentStep >= 0),
      Steps(
          title: "profile setup",
          icon: Icons.person_outline,
         /*  onTapped: () {
            if (formKey.currentState!.validate() && cubit.currentStep != 2) {
              formKey.currentState!.save();
              cubit.setTappedStep(1);
            }
          }, */
          completed: cubit.currentStep > 1,
          content: profileSetupPortraitMode(cubit, formKey2),
          isActive: cubit.currentStep >= 1),
      Steps(
          title: "Complete",
          icon: Icons.email_outlined,
          completed: cubit.currentStep > 2,
          content: verificationScreen(context,emailcontroller.text,passcontroller.text),
          isActive: cubit.currentStep >= 2),
    ];
  }

  Widget profileSetupPortraitMode(signupCubit cubit, var formKey2) {
    return Form(
      key: formKey2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: cubit.coverimgFile == null
                        ? Image.asset(
                            'assets/noCover.jpg',
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            cubit.coverimgFile!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[400],
                    child: IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (ctx) => sheetWidget(context, profile:false,signUpScreen: true));
                      },
                      icon: const FittedBox(
                          child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      )),
                    ),
                  ),
                ],
              ),
              Positioned(
                  bottom: -40,
                  child: profilePicWidget(
                    signupCubit: cubit,
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (ctx) => sheetWidget(context, profile:true,signUpScreen: true));
                    },
                  signUpScreen: true,editProfileScreen: false),),
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                defaultFormField(
                                          context: context,

                    prefixWidget: const Icon(Icons.location_on_outlined),
                    contoller: locationController,
                    labelText: "Location (Optional)",
                    readonly: true,
                    onTap: () async {
                      locationController.text = await getAddress();
                    },
                    //label: const Text("(Optional)",style: TextStyle(color: Colors.green),),
                    filled: true,
                    type: TextInputType.streetAddress),
                defaultFormField(
                                          context: context,

                    prefixWidget: const Icon(Icons.phone),
                    contoller: phonecontroller,
                    labelText: "Phone (Optional)",
                    filled: true),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: defaultElevatedButton(
                    height: 50, text: 'Back', onPressed: cubit.backCurrentStep),
              ),
              const Spacer(),
              cubit.signupLoading
                  ? const CircularProgressIndicator()
                  : Expanded(
                      child: defaultElevatedButton(
                        height: 50,
                        text: 'Next',
                        onPressed: () async {
                          /* if (formKey2.currentState!.validate()) {
                      formKey2.currentState!.save(); */
                          //cubit.imgFile ??= await getImageFileFromAssets('assets/person.png');
                          cubit.signUp(
                              email: emailcontroller.text,
                              phone: phonecontroller.text,
                              username: usernameController.text,
                              pass: passcontroller.text,
                              location: locationController.text,
                              ctx: context);
                          //cubit.forwardCurrentStep();هناك
                        },
                        /* else {
                      cubit.forwardCurrentStep();
                    }
                  }, */
                        width: double.infinity,
                      ),
                    ),
            ],
          )
        ],
      ),
    );
  }

  Widget portraitMode(var formKey) {
    var cubit = signupCubit.get(context);

    return Padding(
      padding: const EdgeInsets.only(top: 30.0, left: 20, right: 20),
      child: Form(
        key: formKey,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly, ملهاش معني عشان سينجل سكرول
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  defaultFormField(
                                            context: context,

                      prefixWidget: const Icon(Icons.email_outlined),
                      contoller: emailcontroller,
                      labelText: "Email Address",
                      filled: true,
                      validate: (String? value) {
                        if (value!.isEmpty) {
                          return 'please enter your email';
                        }
                        if (!emailValid.hasMatch(value)) {
                          return 'bad formatted email';
                        }
                        return null;
                      },
                      type: TextInputType.emailAddress),

                  defaultFormField(
                                            context: context,

                      prefixWidget: const Icon(Icons.person),
                      contoller: usernameController,
                      labelText: "Username",
                      validate: (String? value) {
                        if (value!.isEmpty) {
                          return 'please enter your username';
                        }
                        return null;
                      },
                      filled: true),

                  defaultFormField(
                                            context: context,

                      prefixWidget: const Icon(Icons.lock),
                      contoller: passcontroller,
                      labelText: "Password",
                      isPassword: true,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return 'please enter your password';
                        }
                        if (value.length < 4) {
                          return 'password too short';
                        }
                        return null;
                      },
                      filled: true),
                  //const Spacer(),
                ],
              ),
            ),
            defaultElevatedButton(
              height: 50,
              width: double.infinity,
              text: 'Next',
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  // cubit.imgFile ??= await getImageFileFromAssets('assets/person.png');

                  cubit.forwardCurrentStep();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
