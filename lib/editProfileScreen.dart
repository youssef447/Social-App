import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/Cubit/social/socialCubit.dart';
import 'package:social_app/Cubit/social/socialStates.dart';
import 'package:social_app/shared/styles/themes.dart';

import 'constants.dart';
import 'shared/components.dart';

class editProfileScreen extends StatelessWidget {
  editProfileScreen({super.key});
  final formKey = GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  TextEditingController locationController = TextEditingController();

  TextEditingController bioController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    /*  SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]); */
    var cubit = socialCubit.get(context);
    return BlocConsumer<socialCubit, socialStates>(
      listener: ((context, state) {}),
      builder: ((context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title:  const Text('Edit profile',),
            centerTitle: true,
            actions: [
              TextButton(
                onPressed: () {
                  print('${cubit.user!.getToken}');
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();

                    cubit.editProfile(
                        email: emailcontroller.text,
                        location: locationController.text,
                        username: usernameController.text,
                        pass: passcontroller.text,
                        phone: phonecontroller.text,
                        bio: bioController.text,
                        ctx: context);
                  }
                },
                child: cubit.editProfileLoading
                    ? const CircularProgressIndicator()
                    : Text(
                        'Save',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      clipBehavior: Clip.none,
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Hero(
                              tag: cubit.user!.coverImageUrl != null
                                  ? 'networkcover'
                                  : 'assetcover',
                              child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  child: cubit.coverimgFile != null
                                      ? Image.file(
                                          cubit.coverimgFile!,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                      : cubit.user!.coverImageUrl != null
                                          ? Image.network(
                                              cubit.user!.coverImageUrl!,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                            )
                                          : Image.asset(
                                              'assets/noCover.jpg',
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            )),
                            ),
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey[400],
                              child: IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (ctx) => sheetWidget(context,
                                          profile: false, signUpScreen: false));
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
                          //هتقف عند البوتوم وتنزل 40..لو + العكس
                          bottom: -40,
                          child: profilePicWidget(
                              socialCubit: cubit,
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (ctx) => sheetWidget(context,
                                        profile: true, signUpScreen: false));
                              },
                              signUpScreen: false,
                              editProfileScreen: true),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 45.0, bottom: 8),
                      child: TextFormField(
                        controller: bioController,
                        decoration: InputDecoration(
                          // prefixIcon:  Icon(Icons.biotech),

                          label: const Center(
                            child: Text(
                              "Add bio...",
                            ),
                          ),
                          helperText: cubit.user!.bio ?? '',
                          border: InputBorder.none,
                                labelStyle:  Theme.of(context).textTheme.subtitle1,

                          hintStyle: const TextStyle(color: Colors.black),
                          helperStyle:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    color: Colors.grey[400],
                                  ),

                              fillColor: Colors.grey[200],
                         // filled: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 45.0, bottom: 8),
                      child: defaultFormField(
                          context: context,
                          prefixWidget: const Icon(Icons.email_outlined,),
                          contoller: emailcontroller,
                          labelText: "Email Address",
                          helperText: cubit.user!.email,
                          filled: true,
                          validate: (String? value) {
                            if (value!.isNotEmpty) {
                              if (!emailValid.hasMatch(value)) {
                                return 'bad formatted email';
                              }
                              return null;
                            }
                            return null;
                          },
                          type: TextInputType.emailAddress),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: defaultFormField(
                        context: context,
                        prefixWidget: const Icon(Icons.person),
                        contoller: usernameController,
                        labelText: "Username",
                        helperText: cubit.user!.username,
                        /* validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'please enter your username';
                            }
                            return null;
                          }, */
                        filled: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: defaultFormField(
                        context: context,
                        prefixWidget: const Icon(Icons.lock),
                        contoller: passcontroller,
                        labelText: "New password",
                        helperText: "at least 6 characters",
                        isPassword: true,
                        validate: (value) {
                          if (value!.isNotEmpty) {
                            if (value.length < 6) {
                              return 'password too short';
                            }
                            return null;
                          }
                          return null;
                        },
                        filled: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: defaultFormField(
                          context: context,
                          prefixWidget: const Icon(Icons.location_on_outlined),
                          contoller: locationController,
                          helperText: cubit.user!.getLocation ?? '',
                          labelText: "Location",
                          readonly: true,
                          onTap: () async {
                            locationController.text = await getAddress();
                          },
                          //label: const Text("(Optional)",style: TextStyle(color: Colors.green),),
                          filled: true,
                          type: TextInputType.streetAddress),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: defaultFormField(
                        context: context,

                        prefixWidget: const Icon(Icons.phone),
                        contoller: phonecontroller,
                        helperText: cubit.user!.phone ?? '',
                        // label:Text("Phone") ,
                        labelText: "phone",
                        filled: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
