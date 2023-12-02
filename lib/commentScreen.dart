import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/Cubit/social/socialCubit.dart';
import 'package:social_app/Cubit/social/socialStates.dart';

import 'package:social_app/constants.dart';
import 'package:social_app/postCommentUploadImage.dart';
import 'package:social_app/shared/components.dart';

import 'likesScreen.dart';
import 'models/post.dart';

class commentScreen extends StatefulWidget {
  socialCubit cubit;
  int currentPostIndex;
  String postUid;
  Post post;
  commentScreen({
    super.key,
    required this.cubit,
    required this.currentPostIndex,
    required this.postUid,
    required this.post,
  });

  @override
  State<commentScreen> createState() => _commentScreenState();
}

class _commentScreenState extends State<commentScreen> {
  TextEditingController commentController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.cubit.getComments(widget.postUid, widget.currentPostIndex);
  }

  int index2 = 0;
  var focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<socialCubit, socialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: state is socialGetDataLoadingState
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: EdgeInsets.only(
                    top: topPadding + 10,
                    left: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (widget.post.likes.isNotEmpty) {
                                naviagte(
                                    context,
                                    likesScreen(
                                        cubit: widget.cubit,
                                        postIndex: widget.currentPostIndex));
                              }
                            },
                            child: Text(
                              '${widget.post.likes.length} Likes',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Comments',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      widget.post.comments.isEmpty
                          ? Expanded(
                              //another column to make the no comment text centered
                              child: Column(
                                // mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Spacer(),
                                  Text(
                                    'No comments yet',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(color: Colors.grey[400]),
                                  ),
                                  widget.cubit.commentImage != null
                                      ? postCommentUploadImage(
                                          cubit: widget.cubit,
                                          post: false,
                                        )
                                      : const Spacer(),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: defaultFormField(
                                              contoller: commentController,
                                              filled: true,
                                              radius: 50.0,
                                              focusNode: focusNode,
                                              borderNone: true,
                                              context: context,
                                              suffixWidget: IconButton(
                                                onPressed: () =>
                                                    showModalBottomSheet(
                                                  context: context,
                                                  builder: (ctx) => sheetWidget(
                                                    context,
                                                    profile: false,
                                                    comment: true,
                                                    signUpScreen: false,
                                                  ),
                                                ),
                                                icon: const Icon(
                                                  Icons.photo_outlined,
                                                  color: defaultColor,
                                                ),
                                              ),
                                              hintText: 'write comment...'),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            if (commentController
                                                .text.isNotEmpty) {
                                              widget.cubit.addComment(

                                                  ///profile: widget.profile,
                                                  text: commentController.text,
                                                  currentPostIndex:
                                                      widget.currentPostIndex,
                                                  postUid: widget.post.postUID);
                                            } else if (widget
                                                    .cubit.commentImage !=
                                                null) {
                                              if (widget.cubit.replying) {
                                                String postUid =
                                                    widget.post.postUID;
                                                String commentDocUid = widget
                                                    .post
                                                    .comments[index2]
                                                    .commentUid!;

                                                widget.cubit.addReply(
                                                  //profile: widget.profile,
                                                  text: commentController.text,
                                                  postUid: postUid,
                                                  currentPostIndex:
                                                      widget.currentPostIndex,
                                                  commentIndex: index2,
                                                  commentUid: commentDocUid,
                                                );

                                                //commentController.clear();
                                              } else {
                                                widget.cubit.addComment(
                                                    ////profile: widget.profile,
                                                    text:
                                                        commentController.text,
                                                    currentPostIndex:
                                                        widget.currentPostIndex,
                                                    postUid:
                                                        widget.post.postUID);

                                                //commentController.clear();
                                              }
                                            }
                                          },
                                          icon: const Icon(Icons.send_outlined))
                                    ],
                                  )
                                ],
                              ),
                            )
                          : Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        ListView.separated(
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(
                                            height: 18,
                                          ),
                                          shrinkWrap: true,
                                          itemCount:
                                              widget.post.comments.length,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            print(
                                                'hhhhhhhhhh ${widget.post.comments[index].comment} ${widget.post.comments.length}');
                                            return comment(context,
                                                widget.post.postUID, index);
                                          },
                                        ),
                                        widget.cubit.commentImage != null
                                            ? SizedBox(
                                                height: 300,
                                                child: postCommentUploadImage(
                                                  cubit: widget.cubit,
                                                  post: false,
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: defaultFormField(
                                              contoller: commentController,
                                              filled: true,
                                              radius: 50.0,
                                              borderNone: true,
                                              focusNode: focusNode,
                                              suffixWidget: IconButton(
                                                onPressed: () =>
                                                    showModalBottomSheet(
                                                  context: context,
                                                  builder: (ctx) => sheetWidget(
                                                      context,
                                                      profile: false,
                                                      comment: true,
                                                      signUpScreen: false),
                                                ),
                                                icon: const Icon(
                                                  Icons.photo_outlined,
                                                  color: defaultColor,
                                                ),
                                              ),
                                              context: context,
                                              hintText: 'write comment...'),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            if (commentController
                                                .text.isNotEmpty) {
                                              if (widget.cubit.replying) {
                                                String postUid =
                                                    widget.post.postUID;
                                                String commentDocUid = widget
                                                    .post
                                                    .comments[index2]
                                                    .commentUid!;
                                                /*  int replyIndex =
                                            widget.cubit.pressedReplyIndex; */
                                                widget.cubit.addReply(
                                                  //profile: widget.profile,
                                                  text: commentController.text,
                                                  postUid: postUid,
                                                  currentPostIndex:
                                                      widget.currentPostIndex,
                                                  commentIndex: index2,
                                                  commentUid: commentDocUid,
                                                );

                                                //commentController.clear();
                                              } else {
                                                widget.cubit.addComment(
                                                    // //profile: widget.profile,
                                                    text:
                                                        commentController.text,
                                                    currentPostIndex:
                                                        widget.currentPostIndex,
                                                    postUid:
                                                        widget.post.postUID);

                                                //commentController.clear();
                                              }
                                              focusNode.unfocus();
                                            } else if (widget
                                                    .cubit.commentImage !=
                                                null) {
                                              if (widget.cubit.replying) {
                                                String postUid =
                                                    widget.post.postUID;
                                                String commentDocUid = widget
                                                    .post
                                                    .comments[index2]
                                                    .commentUid!;

                                                widget.cubit.addReply(
                                                  //profile: widget.profile,
                                                  text: commentController.text,
                                                  postUid: postUid,
                                                  currentPostIndex:
                                                      widget.currentPostIndex,
                                                  commentIndex: index2,
                                                  commentUid: commentDocUid,
                                                );

                                                //commentController.clear();
                                              } else {
                                                widget.cubit.addComment(
                                                    //profile: widget.profile,
                                                    text:
                                                        commentController.text,
                                                    currentPostIndex:
                                                        widget.currentPostIndex,
                                                    postUid:
                                                        widget.post.postUID);

                                                //commentController.clear();
                                              }
                                            }
                                          },
                                          icon: const Icon(Icons.send_outlined))
                                    ],
                                  )
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget comment(
    BuildContext context,
    String postUid,
    int index,
  ) {
    socialCubit cubit = widget.cubit;
    //int index = index;
    String commentDocUid = widget.post.comments[index].commentUid!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundImage: NetworkImage(
              cubit.users[widget.post.comments[index].uID]!.profileIimageUrl!),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                constraints: BoxConstraints(
                  maxWidth: width! - 10 - 44 - 10 - 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[350],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cubit.users[widget.post.comments[index].uID]!.username,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.post.comments[index].comment!,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: Colors.black),
                    ),
                    widget.post.comments[index].commentIimageUrl!.isNotEmpty
                        ? Image.network(
                            widget.post.comments[index].commentIimageUrl!)
                        : const SizedBox(),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    DateTime.now()
                                .difference(
                                    widget.post.comments[index].now.toDate())
                                .inDays >=
                            1
                        ? '${DateTime.now().difference(widget.post.comments[index].now.toDate()).inDays} days'
                        : DateTime.now()
                                    .difference(widget.post.comments[index].now
                                        .toDate())
                                    .inHours >=
                                1
                            ? '${DateTime.now().difference(widget.post.comments[index].now.toDate()).inHours} h'
                            : '${DateTime.now().difference(widget.post.comments[index].now.toDate()).inMinutes} min',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  IconButton(
                    onPressed: () {
                      widget.cubit.likeComment(
                          currentPostIndex: widget.currentPostIndex,
                          currentCommentIndex: index,
                          commentUid: commentDocUid,
                          //profile: widget.profile,
                          postUid: postUid);
                    },
                    icon: widget.post.comments[index].likes
                            .contains(widget.cubit.user!.getToken)
                        ? const Icon(
                            Icons.favorite,
                            color: defaultColor,
                          )
                        : const Icon(
                            Icons.favorite_outline,
                            color: defaultColor,
                          ),
                  ),
                  Text(
                    widget.post.comments[index].likes.length.toString(),
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  TextButton(
                    onPressed: () {
                      index2 = index;
                      print('comment num ${index + 1} pressed ');

                      if (widget.cubit.replying == true) {
                        focusNode.unfocus();

                        widget.cubit.commentReplySwitch(false);
                        //FocusScope.of(context).unfocus();

                      } else {
                        FocusScope.of(context).requestFocus(focusNode);

                        //focusNode.requestFocus();
                        widget.cubit.commentReplySwitch(true);
                      }
                    },
                    child: Text(
                      'reply',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ],
              ),
              widget.post.comments[index].replies.isEmpty
                  ? const SizedBox()
                  : cubit.showReplies
                      ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.post.comments[index].replies.length,
                          itemBuilder: (context, indexList) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundImage: NetworkImage(cubit
                                      .users[widget.post.comments[index]
                                          .replies[indexList].uID]!
                                      .profileIimageUrl!),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      constraints: BoxConstraints(
                                        maxWidth: width! -
                                            10 -
                                            44 -
                                            10 -
                                            10 -
                                            40 -
                                            10,
                                      ), //maxHeight: 300),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 241, 214, 214),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              cubit
                                                  .users[widget
                                                      .post
                                                      .comments[index]
                                                      .replies[indexList]
                                                      .uID]!
                                                  .username,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1!
                                                  .copyWith(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            widget.post.comments[index]
                                                .replies[indexList].comment!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(color: Colors.black),
                                          ),
                                          widget
                                                  .post
                                                  .comments[index]
                                                  .replies[indexList]
                                                  .commentIimageUrl!
                                                  .isNotEmpty
                                              ? Image.network(widget
                                                  .post
                                                  .comments[index]
                                                  .replies[indexList]
                                                  .commentIimageUrl!)
                                              : const SizedBox(),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          DateTime.now()
                                                      .difference(widget
                                                          .post
                                                          .comments[index]
                                                          .replies[indexList]
                                                          .now
                                                          .toDate())
                                                      .inDays >=
                                                  1
                                              ? '${DateTime.now().difference(widget.post.comments[index].replies[indexList].now.toDate()).inDays} days'
                                              : DateTime.now()
                                                          .difference(widget
                                                              .post
                                                              .comments[index]
                                                              .replies[
                                                                  indexList]
                                                              .now
                                                              .toDate())
                                                          .inHours >=
                                                      1
                                                  ? '${DateTime.now().difference(widget.post.comments[index].replies[indexList].now.toDate()).inHours} h'
                                                  : '${DateTime.now().difference(widget.post.comments[index].replies[indexList].now.toDate()).inMinutes} min',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1,
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            String uid = widget
                                                .post
                                                .comments[index]
                                                .replies[indexList]
                                                .commentUid!;
                                            widget.cubit.likeReply(
                                                currentPostIndex:
                                                    widget.currentPostIndex,
                                                postUid: postUid,
                                                commentUid: commentDocUid,
                                                commentIndex: index,
                                                replyUid: uid,
                                                replyIndex: indexList);
                                          },
                                          icon: widget.post.comments[index]
                                                  .replies[indexList].likes
                                                  .contains(widget
                                                      .cubit.user!.getToken)
                                              ? const Icon(
                                                  Icons.favorite,
                                                  color: defaultColor,
                                                )
                                              : const Icon(
                                                  Icons.favorite_outline,
                                                  color: defaultColor,
                                                ),
                                        ),
                                        Text(
                                          widget.post.comments[index]
                                              .replies[indexList].likes.length
                                              .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1,
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            );
                          },
                        )
                      : GestureDetector(
                          onTap: () => cubit.showRep(true),
                          child: Text(
                            'view ${widget.post.comments[index].replies.length} replies...',
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        )
            ],
          ),
        )
      ],
    );
  }
}
