import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/Cubit/social/socialCubit.dart';
import 'package:social_app/Cubit/social/socialStates.dart';
import 'package:social_app/constants.dart';
import 'package:social_app/shared/components.dart';

import 'postCommentUploadImage.dart';

class addPostScreen extends StatelessWidget {
  addPostScreen({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();
  TextEditingController postController = TextEditingController();
  FocusNode node = FocusNode();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return BlocConsumer<socialCubit, socialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = socialCubit.get(context);

        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text(
              'create post',
            ),
            centerTitle: true,
            actions: [
              cubit.postLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed:
                            cubit.post.isNotEmpty || cubit.postImage != null
                                ? () {
                                    if (formKey.currentState != null) {
                                      formKey.currentState!.save();
                                    }

                                    cubit.createPost(
                                        ctx: context,
                                        text: postController.text);
                                  }
                                : null,
                        child: Text(
                          'POST',
                          style: cubit.post.isEmpty && cubit.postImage == null
                              ? Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(color: Colors.grey[400])
                              : const TextStyle(color: defaultColor),
                        ),
                      ),
                    )
            ],
          ),
          body: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: cubit.user!.profileIimageUrl == null
                          ? const AssetImage('assets/person.png')
                          : NetworkImage(
                              cubit.user!.profileIimageUrl!,
                            ) as ImageProvider,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    cubit.user!.username,
                    style: Theme.of(context).textTheme.bodyText1,
                  )
                ],
              ),
              Expanded(
                child: defaultFormField(
                    context: context,
                    focusNode: node,
                    contoller: postController,
                    hintText: 'What\'s on your mind?',
                    borderNone: true,
                    expand: true,
                    onchanged: (str) {
                      cubit.checkPostFormLength(str);
                    }),
              ),
              cubit.postImage != null
                  ? postCommentUploadImage(cubit: cubit,post: true,)
                  : const SizedBox(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        node.unfocus();
                        showModalBottomSheet(
                            context: context,
                            builder: (ctx) => sheetWidget(context,
                                profile: false,
                                signUpScreen: false,
                                post: true));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.photo_outlined,
                              color: defaultColor,
                            ),
                            Text(
                              ' Photo',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        node.unfocus();

                        showModalBottomSheet(
                            context: context,
                            builder: (ctx) => sheetWidget(context,
                                post: true,
                                video: true,
                                profile: false,
                                signUpScreen: false));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.videocam_outlined,
                              color: defaultColor,
                            ),
                            Text(
                              'Video',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.tag_outlined,
                              color: defaultColor,
                            ),
                            Text(
                              'Tag',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
