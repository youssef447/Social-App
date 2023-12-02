import 'package:flutter/material.dart';
import 'package:social_app/Cubit/social/socialCubit.dart';
import 'package:social_app/constants.dart';

class postCommentUploadImage extends StatelessWidget {
  final socialCubit cubit;
  final bool post;
  bool? message;
  postCommentUploadImage(
      {super.key, required this.cubit, required this.post, this.message});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: FileImage(message != null
                    ? cubit.messageImg!
                    : post
                        ? cubit.postImage!
                        : cubit.commentImage!),
                fit: BoxFit.cover),
          ),
        ),
        IconButton(
          onPressed: () {
            message != null
                ? cubit.removeMessagetImage()
                : post
                    ? cubit.removePostImage()
                    : cubit.removeCommentImage();
          },
          icon: const Icon(
            Icons.cancel,
            color: defaultColor,
            size: 35,
          ),
        ),
      ],
    );
  }
}
