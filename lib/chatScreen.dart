
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/Cubit/social/socialCubit.dart';
import 'package:social_app/Cubit/social/socialStates.dart';
import 'package:social_app/constants.dart';
import 'package:social_app/shared/components.dart';
import 'package:intl/intl.dart';

import 'models/message.dart';
import 'models/user.dart';
import 'postCommentUploadImage.dart';

class chatScreen extends StatefulWidget {
  final User user;
  const chatScreen({
    super.key,
    required this.user,
  });

  @override
  State<chatScreen> createState() => _chatScreenState();
}

class _chatScreenState extends State<chatScreen> {
  final TextEditingController _messageController = TextEditingController();
  var focusNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    socialCubit.get(context).getMessages(recieverId: widget.user.getToken);
  }

  @override
  Widget build(BuildContext context) {
    socialCubit cubit = socialCubit.get(context);
    return BlocConsumer<socialCubit, socialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              systemOverlayStyle:
                  const SystemUiOverlayStyle(statusBarColor: defaultColor,),
              backgroundColor: defaultColor,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: widget.user.profileIimageUrl == null
                        ? const AssetImage('assets/person.png')
                        : NetworkImage(widget.user.profileIimageUrl!)
                            as ImageProvider,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    widget.user.username,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
            body: state is getMessageLoadingState
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 8.0),
                    child: Column(
                      children: [
                        cubit.messages.isNotEmpty
                            ? Expanded(
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    ListView.separated(
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return cubit.messages[index]
                                                      .senderId ==
                                                  cubit.user!.getToken
                                              ? _buildMyMessage(
                                                  cubit.messages[index],
                                                  context)
                                              : _buildMessage(
                                                  cubit.messages[index],
                                                  context);
                                        },
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(
                                              height: 10,
                                            ),
                                        itemCount: cubit.messages.length),
                                    cubit.messageImg != null
                                        ? SizedBox(
                                            height: 300,
                                            child: postCommentUploadImage(
                                              cubit: cubit,
                                              post: false,
                                              message: true,
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              )
                            : Expanded(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/noMessage.png',
                                        ),
                                        Text(
                                          'No messages yet',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: defaultFormField(
                                    contoller: _messageController,
                                    filled: true,
                                    radius: 50.0,
                                    borderNone: true,
                                    focusNode: focusNode,
                                    suffixWidget: IconButton(
                                      onPressed: () => showModalBottomSheet(
                                        context: context,
                                        builder: (ctx) => sheetWidget(context,
                                            profile: false,
                                            message: true,
                                            signUpScreen: false),
                                      ),
                                      icon: const Icon(
                                        Icons.photo_outlined,
                                        color: defaultColor,
                                      ),
                                    ),
                                    context: context,
                                    hintText: 'Message'),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  if (_messageController.text.isNotEmpty ||
                                      cubit.messageImg != null) {
                                    cubit.sendMessage(
                                      recieverId: widget.user.getToken,
                                      text: _messageController.text,
                                    );
                                  }
                                },
                                icon: const Icon(Icons.send_outlined))
                          ],
                        )
                      ],
                    ),
                  ),
          );
        });
  }

  Widget _buildMessage(Message message, BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: widget.user.profileIimageUrl == null
                ? const AssetImage('assets/person.png')
                : NetworkImage(widget.user.profileIimageUrl!) as ImageProvider,
          ),
          const SizedBox(
            width: 15,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            constraints: BoxConstraints(
                maxHeight:
                    (MediaQuery.of(context).size.height - topPadding) * 0.4,
                maxWidth: width! - 15 - 40),
            decoration: BoxDecoration(
              color: socialCubit.get(context).isDark
                  ? const Color(0XFF233040)
                  : Colors.grey[350],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.text ?? '',
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: socialCubit.get(context).isDark
                          ? Colors.white
                          : Colors.black),
                ),
                const SizedBox(
                  height: 5,
                ),
                message.imgUrl!.isNotEmpty
                    ? Expanded(child: Image.network(message.imgUrl!))
                    : const SizedBox(),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  DateFormat('hh:mm aa').format(message.time.toDate()),
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      fontSize: 10,
                      color: socialCubit.get(context).isDark
                          ? Colors.white
                          : Colors.black),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyMessage(Message message, BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(10),
        constraints: BoxConstraints(
            maxHeight: (MediaQuery.of(context).size.height - topPadding) * 0.4,
            maxWidth: width! - 15 - 40),
        decoration: const BoxDecoration(
          color: defaultColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            message.imgUrl!.isNotEmpty
                ? Expanded(child: Image.network(message.imgUrl!))
                : const SizedBox(),
            const SizedBox(
              height: 5,
            ),
            Text(
              message.text ?? '',
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: Colors.white),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('hh:mm aa').format(message.time.toDate()),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontSize: 10, color: Colors.white),
                ),
                const Icon(
                  Icons.done,
                  size: 15,
                  color: Colors.white,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
