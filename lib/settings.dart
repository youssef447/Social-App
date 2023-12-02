import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/Cubit/social/socialCubit.dart';
import 'package:social_app/Cubit/social/socialStates.dart';
import 'package:social_app/addPostScreen.dart';
import 'package:social_app/postCard.dart';

import 'constants.dart';
import 'editProfileScreen.dart';
import 'models/user.dart';
import 'shared/components.dart';
import 'shared/styles/icon_broken.dart';

class settingsScreen extends StatefulWidget {
  const settingsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<settingsScreen> createState() => _settingsScreenState();
}

class _settingsScreenState extends State<settingsScreen> {
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
        User user = cubit.user!;

        return Padding(
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
                  height:
                      orientation == Orientation.portrait ? h * 0.25 : h * 0.5,
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
                      Column(
                        children: [
                          Text(
                            cubit.user!.followers.length.toString(),
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Text(
                            'Followers',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            cubit.user!.following.length.toString(),
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Text(
                            'Following',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            cubit.user!.numberOfPosts.toString(),
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
                      child: OutlinedButton(
                        onPressed: () {
                          cubit.postImage = null;

                          naviagte(context, addPostScreen());
                        },
                        child: const Text('Add Post'),
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(Colors.white),
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
                          naviagte(context, editProfileScreen());
                        },
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(Colors.white),
                          foregroundColor:
                              MaterialStateProperty.all(defaultColor),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            Text('edit profile'),
                            Icon(
                              IconBroken.Edit,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                cubit.posts
                        .where((element) => element.uID == cubit.user!.getToken)
                        .isNotEmpty
                    ? ListView.separated(
                        separatorBuilder: (context, index) => SizedBox(
                          height: h * 0.03,
                        ),
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 10),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cubit.user!.numberOfPosts,
                        itemBuilder: (context, index) {
                          return postCard(
                            cubit: cubit,
                            index: index,
                            //filter only my posts
                            posts: cubit.posts
                                .where((element) =>
                                    element.uID == cubit.user!.getToken)
                                .toList(),
                          );
                        },
                      )
                    : 
                       
                        Column(
                          children: [
                            const SizedBox(height: 40,),
                            Text(
                                'You Haven\'t add posts yet',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                          ],
                        ),
                   
              ],
            ),
          ),
        );
      },
    );
  }
}
