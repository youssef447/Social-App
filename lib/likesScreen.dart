import 'package:flutter/material.dart';

import 'package:social_app/Cubit/social/socialCubit.dart';
import 'package:social_app/constants.dart';
import 'package:social_app/shared/components.dart';

class likesScreen extends StatelessWidget {
  final socialCubit cubit;
  final int postIndex;
  final bool? profile;
  const likesScreen({required this.cubit, super.key, required this.postIndex,this.profile});

  @override
  Widget build(BuildContext context) {
    //print('hhhhhhhhhhhhhh ${cubit.postsID[index]}');

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  Text(
                    'Likes',
                    style: Theme.of(context).textTheme.bodyText1,
                  )
                ],
              ),
              const SizedBox(height: 15,),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          child: CircleAvatar(
                            radius: 23,
                            backgroundImage: cubit
                                        .users[
                                            cubit.posts[postIndex].likes[index]]!
                                        .profileIimageUrl ==
                                    null
                                ? const AssetImage('assets/person.png')
                                    as ImageProvider
                                : NetworkImage(cubit
                                    .users[cubit.posts[postIndex].likes[index]]!
                                    .profileIimageUrl!),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          cubit.users[cubit.posts[postIndex].likes[index]]!
                              .username,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        const Spacer(),
                        cubit.posts[postIndex].likes[index] ==
                                cubit.user!.getToken
                            ? const SizedBox()
                            : cubit.user!.following.contains(
                                    cubit.posts[postIndex].likes[index])
                                ? defaultElevatedButton(
                                    text: 'unfollow',
                                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                    radius: 5,
                                    elevation: 0,
                                    onPressed: () {
                                      cubit.unfollowUser(
                                          cubit.posts[postIndex].likes[index]);
                                    },
                                  )
                                : defaultElevatedButton(
                                    text: 'follow',
                                    backgroundColor: defaultColor,
                                    radius: 5,
                                    elevation: 0,
                                    onPressed: () {
                                      cubit.followUser(
                                          cubit.posts[postIndex].likes[index]);
                                    },
                                  ),
                      ],
                    );
                  },
                  itemCount: cubit.posts[postIndex].likes.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
