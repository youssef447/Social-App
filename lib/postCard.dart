import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Cubit/social/socialCubit.dart';
import 'commentScreen.dart';
import 'constants.dart';
import 'models/post.dart';

class postCard extends StatelessWidget {
  final socialCubit cubit;
  final int index;
  final List<Post> posts;
  const postCard(
      {super.key,
      required this.cubit,
      required this.index,
      required this.posts,
      });

  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 10,
      shadowColor: Theme.of(context).scaffoldBackgroundColor,
      color: cubit.isDark
          ? const Color(0XFF233040)
          : Theme.of(context).scaffoldBackgroundColor,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: const EdgeInsets.only(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  
                  backgroundImage: cubit
                          .users[posts[index].uID]!.profileIimageUrl!.isEmpty
                      ? const AssetImage('assets/person.png')
                      : NetworkImage(
                              cubit.users[posts[index].uID]!.profileIimageUrl!)
                          as ImageProvider,
                ),
                const SizedBox(
                  // height: 200,
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          cubit.users[posts[index].uID]!.username,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    Text(
                        DateTime.now().day == posts[index].now.day
                            ? 'Today At ${DateFormat('hh:mm aa').format((posts[index].now))}'
                            : DateFormat('dd /MM, yyyy At hh:mm aa').format(
                                posts[index]
                                    .now), //'January 21, 2021 at 11:00 pm',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(height: 1.2))
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_horiz_outlined),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(
                thickness: 0,
                color: Theme.of(context).dividerTheme.color,
              ),
            ),
            Text(
              posts[index].text!,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(
              height: 10,
            ),
            posts[index].postIimageUrl!.isNotEmpty
                ? Image.network(
                    posts[index].postIimageUrl!,
                    fit: BoxFit.contain,
                  )
                : const SizedBox(),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    
                    isScrollControlled: true,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    builder: (ctx) {
                      return commentScreen(
                        cubit: cubit,
                        postUid: posts[index].postUID,
                        post: posts[index],
                        currentPostIndex: index,
                      );
                    }).whenComplete(() {
              cubit.showRep(false);
}
);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        posts[index].likes.length.toString(),
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                    Text(
                      'likes',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    const Spacer(),
                    Text(
                    '${posts[index].TotalComments} comments' ,
                      style: Theme.of(context).textTheme.subtitle2,
                    )
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 0,
              color: Theme.of(context).dividerTheme.color,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    cubit.likedPost(
                        currentPostIndex: index,
                        postUid: posts[index].postUID,
                        );
                  },
                  icon: posts[index].likes.contains(cubit.user!.getToken)
                      ? const Icon(
                          Icons.favorite,
                          color: defaultColor,
                        )
                      : const Icon(
                          Icons.favorite_outline,
                          color: defaultColor,
                        ),
                ),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        )),
                        builder: (ctx) {
                          return commentScreen(
                            cubit: cubit,
                            //profile:profile,
                            post: posts[index],
                           postUid:posts[index].postUID,
                            currentPostIndex: index,
                          );
                        });
                  },
                  icon: Icon(
                    Icons.comment_outlined,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.share_outlined,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: ()=>cubit.savePost(posts[index].postUID),
                  icon: Icon(
                    Icons.bookmark_outline,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
