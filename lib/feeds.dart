import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/Cubit/social/socialCubit.dart';
import 'package:social_app/Cubit/social/socialStates.dart';
import 'package:social_app/addPostScreen.dart';
import 'package:social_app/constants.dart';

import 'postCard.dart';
import 'shared/components.dart';

class feedsScreen extends StatelessWidget {
  const feedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    height = Scaffold.of(context).appBarMaxHeight;
    var cubit = socialCubit.get(context);
    final h = MediaQuery.of(context).size.height -
        height! -
        kBottomNavigationBarHeight -
        bottomMobileBarHeight!;

    final Orientation orientation = MediaQuery.of(context).orientation;

    final w = MediaQuery.of(context).size.width;
    return BlocConsumer<socialCubit, socialStates>(
      listener: (context, state) {},
      builder: (context, state) {
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
                InkWell(
                  onTap: () {
                    // cubit.postImage=null;
                    naviagte(
                      context,
                      addPostScreen(),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.only(),
                    elevation: 15,

                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    /* padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    width: double.infinity, */
                    //height:
                    //orientation == Orientation.portrait ? h * 0.1 : h * 0.3,
                    //   h * 0.15,
                    shadowColor: cubit.isDark
                        ? Colors.black
                        : Theme.of(context).scaffoldBackgroundColor,
                    color: Theme.of(context).scaffoldBackgroundColor,

                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20, left: 10, right: 10, bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Post something',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontWeight: FontWeight.normal),
                          ),
                          Divider(
                            thickness: 0,
                            color: Theme.of(context).dividerTheme.color,
                          ),
                          Row(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 27,
                                  backgroundColor: Colors.grey[300],
                                  backgroundImage: cubit
                                              .user!.profileIimageUrl ==
                                          null
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
                                'What\'s on your mind?',
                                //maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: h * 0.05,
                ),
                cubit.posts
                        .where((element) => element.uID != cubit.user!.getToken)
                        .isEmpty
                    ? Align(
                        alignment: Alignment.center,
                        child: Text(
                          'No Posts Yet',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      )
                    : ListView.separated(
                        separatorBuilder: (context, index) => SizedBox(
                          height: h * 0.03,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: ((context, index) {
                          return postCard(
                              cubit: cubit,
                              index: index,
                              posts: cubit.posts
                                  .where((element) =>
                                      element.uID != cubit.user!.getToken)
                                  .toList());
                        }),
                        itemCount: cubit.posts
                            .where((element) =>
                                element.uID != cubit.user!.getToken)
                            .length,
                      )
              ],
            ),
          ),
        );
      },
    );
  }
}
