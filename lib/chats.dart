import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/Cubit/social/socialStates.dart';
import 'package:social_app/constants.dart';
import 'package:social_app/shared/components.dart';
import 'package:intl/intl.dart';

import 'Cubit/social/socialCubit.dart';
import 'chatScreen.dart';
import 'models/user.dart';
import 'searchUsers.dart';

class chatsScreen extends StatelessWidget {
  const chatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final Orientation orientation = MediaQuery.of(context).orientation;

    return BlocConsumer<socialCubit, socialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        socialCubit cubit = socialCubit.get(context);

        return cubit.chatMessages.isNotEmpty
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
                child: Column(
                  children: [
                    ListView.separated(
                      separatorBuilder: (context, index) => const Divider(thickness: 1,height: 50,),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        User user =
                            cubit.users[cubit.chatMessages[index].recieverId]!;
                        return GestureDetector(
                          onTap: () {
                            /*  SystemChrome.setSystemUIOverlayStyle(
  SystemUiOverlayStyle(statusBarColor:cubit.isDark?const Color(0XFF333739):Colors.white),
);  */
                            naviagte(context, chatScreen(user: user));
                          },
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: CircleAvatar(
                                    radius: 23,
                                    backgroundImage: user.profileIimageUrl ==
                                            null
                                        ? const AssetImage('assets/person.png')
                                            as ImageProvider
                                        : NetworkImage(user.profileIimageUrl!),
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.username,
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),

                                    //cubit.chatMessages[index].lastMessage
                                    Text(
                                      cubit.chatMessages[index].senderId == uID
                                          ? 'You: ${cubit.chatMessages[index].text!.isEmpty ? 'Image' : cubit.chatMessages[index].text}'
                                          //    ??
                                          // 'Image',
                                          : cubit.chatMessages[index].text!
                                                  .isEmpty
                                              ? 'Image'
                                              : cubit.chatMessages[index].text!,
                                      style:
                                          Theme.of(context).textTheme.subtitle2,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Text(
                                  DateFormat('hh:mm:aa').format(
                                    cubit.chatMessages[index].time.toDate(),
                                  ),
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                              ]),
                        );
                      },
                      itemCount: cubit.chatMessages.length,
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/noMessage.png',
                    ),
                    Text(
                      'No Messages yet',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),

                    MaterialButton(
                      color: defaultColor,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Text(
                        'Chat people',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(color: Colors.white),
                      ),
                      onPressed: (() {
                        naviagte(context, const searchUsers());
                      }),
                    )
                    // backgroundColor: defaultColor)
                  ],
                ),
              );
      },
    );
  }
}
