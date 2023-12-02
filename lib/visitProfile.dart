import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/chatScreen.dart';
import 'package:social_app/chats.dart';

import 'Cubit/social/socialCubit.dart';
import 'Cubit/social/socialStates.dart';
import 'constants.dart';
import 'models/user.dart';
import 'postCard.dart';
import 'shared/components.dart';

class visitProifle extends StatelessWidget {
  final User user;
  const visitProifle({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height - bottomMobileBarHeight!;

    final Orientation orientation = MediaQuery.of(context).orientation;
    //final commentController = TextEditingController();
    final w = MediaQuery.of(context).size.width;
    return BlocConsumer<socialCubit, socialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = socialCubit.get(context);

        return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: orientation == Orientation.portrait
                      ? w * 0.02
                      : (w - bottomMobileBarHeight!) * 0.02),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: orientation == Orientation.portrait
                          ? h * 0.25
                          : h * 0.5,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        clipBehavior: Clip.none,
                        children: [
                          user.coverImageUrl == null
                              ? Hero(
                                  tag: 'assetcover',
                                  child: Image.asset(
                                    'assets/noCover.jpg',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                )
                              : Hero(
                                  tag: 'networkcover',
                                  child: Image.network(
                                    user.coverImageUrl!,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          Positioned(
                            bottom: -40,
                            child: profilePicWidget(
                                profileUrl: user.profileIimageUrl,
                                signUpScreen: false,
                                editProfileScreen: false),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      user.username,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      user.bio ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: Colors.grey[400]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              //go to followers screen
                            },
                            child: Column(
                              children: [
                                Text(
                                  user.followers.length.toString(),
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                Text(
                                  'Followers',
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              //go to following screen
                            },
                            child: Column(
                              children: [
                                Text(
                                  user.following.length.toString(),
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                Text(
                                  'Following',
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                user.numberOfPosts.toString(),
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              Text(
                                'Posts',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: cubit.user!.following.contains(user.getToken)
                              ? OutlinedButton(
                                  onPressed: () {
                                    cubit.unfollowUser(user.getToken);
                                  },
                                  child: const Text('Unfollow'),
                                  style: ButtonStyle(
                                    overlayColor:
                                        MaterialStateProperty.all(Colors.white),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    backgroundColor:
                                        MaterialStateProperty.all(defaultColor),
                                  ),
                                )
                              : OutlinedButton(
                                  onPressed: () {
                                    cubit.followUser(user.getToken);
                                  },
                                  child: const Text('Follow'),
                                  style: ButtonStyle(
                                    overlayColor:
                                        MaterialStateProperty.all(Colors.white),
                                    foregroundColor:
                                        MaterialStateProperty.all(defaultColor),
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                  ),
                                ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              naviagte(
                                  context,
                                  chatScreen(
                                    user: user,
                                  ));
                            },
                            style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.white),
                              foregroundColor:
                                  MaterialStateProperty.all(defaultColor),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                            ),
                            child: const Text('Message'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    cubit.posts
                            .where((element) => element.uID == user.getToken)
                            .isNotEmpty
                        ? ListView.separated(
                            separatorBuilder: (context, index) => SizedBox(
                              height: h * 0.03,
                            ),
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 10),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: user.numberOfPosts,
                            itemBuilder: (context, index) {
                              return postCard(
                                cubit: cubit,
                                index: index,

                                //filter only my posts
                                posts: cubit.posts
                                    .where((element) =>
                                        element.uID == user.getToken)
                                    .toList(),
                              );
                            },
                          )
                        : Text(
                            '${user.username.split(' ').first} has no posts yet',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
