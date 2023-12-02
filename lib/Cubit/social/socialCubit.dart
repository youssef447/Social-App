import 'dart:io';
import 'package:rxdart/rxdart.dart';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/Cubit/social/socialEvents.dart';
import 'package:social_app/Network/local/cach_helper.dart';
import 'package:social_app/chats.dart';
import 'package:social_app/feeds.dart';
import 'package:social_app/models/CommentsModel.dart';
import 'package:social_app/models/message.dart';
import 'package:social_app/settings.dart';
import 'package:social_app/shared/components.dart';
import 'package:social_app/users.dart';

import '../../constants.dart';
import '../../models/post.dart';
import '../../models/user.dart';
import 'socialStates.dart';

class socialCubit extends Bloc<socialEvents, socialStates> {
  socialCubit() : super(socialInitialState()) {
    on<searchEvent>(
      (event, emit) {
        return searchUser(emit, event.text);
      },
      transformer: (eventsStream, mapper) => eventsStream
          .debounceTime(const Duration(milliseconds: 300))
          .distinct()
          .switchMap(mapper),
    );
  }

  List<User> searchResults = [];

  searchUser(Emitter<socialStates> emit, String text) async {
    searchResults = [];

    if (text.isNotEmpty) {
      print(searchResults);
      var tmp = await FirebaseFirestore.instance.collection('users').get();
      for (var doc in tmp.docs) {
        String tmp2 = doc.data()['username'].toString().toLowerCase();
        if (tmp2.contains(text)) {
          searchResults.add(User.fromJson(doc.data()));
        }
      }
    }
    emit(searchUserSuccessState());
  }

  static socialCubit get(ctx) => BlocProvider.of(ctx);
  User? user;
  bool isSelected = false;
  bool editProfileLoading = false;
  bool visiblePassword = false;
  String? profileImageUrl;
  String? coverimgUrl;
  String? postImageUrl;
  String? commentImageUrl;
  bool replying = false;
  File? profimgFile;
  File? coverimgFile;
  File? postImage;
  File? commentImage;
  bool isDark = false;
  bool postLoading = false;
  bool showReplies = false;
  int groupValue = 1;
  String post = "";
  Post? createPostModel;
  List<Post> allPoststmp = [];
  List<Post> posts = [];
  List<int> myTotalCommentsReplies = [];

  List<int> totalCommentsReplies = [];
  Map<String, User> users = {};
  int pressedReplyIndex = 0;

  List<CommentsModel> tmpCommentsModel = [];
  List<CommentsModel> tmpReplyModel = [];

  //Map<String, List<CommentsModel>> commentsModel = {};

  likedPost({required String postUid, required int currentPostIndex}) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postUid)
        .get()
        .then((value) {
      List<dynamic> tmp = value.data()!['likes'];
      if (tmp.contains(user!.getToken)) {
        tmp.removeWhere((element) => element == user!.getToken);
        FirebaseFirestore.instance
            .collection('posts')
            .doc(postUid)
            .update({'likes': tmp}).then((value) {
          posts[currentPostIndex].setLikes(tmp);

          emit(dislikedPostState());
        }).catchError((onErrror) {
          emit(checkLikeErrorState(onErrror.toString()));
        });
      } else {
        tmp.add(user!.getToken);
        FirebaseFirestore.instance
            .collection('posts')
            .doc(postUid)
            .update({'likes': tmp}).then((value) {
          posts[currentPostIndex].setLikes(tmp);

          emit(likedPostState());
        }).catchError((onErrror) {
          emit(checkLikeErrorState(onErrror.toString()));
        });
      }
    }).catchError((onError) {
      emit(checkLikeErrorState(onError));
    });
  }

  switchThemeMode({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
    } else {
      isDark = !isDark;

      CacheHelper.saveData(key: 'isDark', value: isDark).then(
        (value) {
          emit(changeThemeModeState());
        },
      );
    }
    if (isDark) {
      groupValue = 2;
    } else {
      groupValue = 1;
    }
  }

  toDarkMode() {
    // isDark = true;
    groupValue = 2;
    CacheHelper.saveData(key: 'isDark', value: true).then(
      (value) {
        isDark = true;

        emit(changeThemeModeState());
      },
    );
  }

  toLightMode() {
    //isDark = false;
    groupValue = 1;
    CacheHelper.saveData(key: 'isDark', value: false).then(
      (value) {
        isDark = false;

        emit(changeThemeModeState());
      },
    );
  }

  changeRadioValue(var index) {
    groupValue = index;
    emit(changeRadioValueState());
  }

  void createPost({required BuildContext ctx, String? text}) async {
    postLoading = true;
    emit(createPostLoadingState());
    if (postImage != null) {
      final storageRef = FirebaseStorage.instance.ref();

      await storageRef
          .child("posts")
          .child(Uri.file(postImage!.path).pathSegments.last)
          .putFile(postImage!);
      postImageUrl = await storageRef
          .child("posts")
          .child(Uri.file(postImage!.path).pathSegments.last)
          .getDownloadURL();
    }
    createPostModel = Post(
        now: DateTime.now(),
        uID: user!.getToken,
        text: text ?? '',
        postIimageUrl: postImageUrl ?? '');

    FirebaseFirestore.instance
        .collection('posts')
        .add(createPostModel!.toMap())
        .then((value) async {
      posts.insert(0, createPostModel!);
      // await value.collection('likes').doc('test').set({});
      await value.collection('comments').doc('test').set({});

      // await value.collection('replies').doc('test').set({});

      int tmp = user!.numberOfPosts + 1;
      //my number of posts
      user!.setNumberOfPosts(tmp);
      FirebaseFirestore.instance
          .collection('users')
          .doc(createPostModel!.uID)
          .get()
          .then((value) async {
        int totalPosts = value.data()!['number of posts'];
        totalPosts += 1;
        FirebaseFirestore.instance
            .collection('users')
            .doc(createPostModel!.uID)
            .update({'number of posts': totalPosts}).then((value) {});

        //update it in database
        FirebaseFirestore.instance
            .collection('users')
            .doc(user!.getToken)
            .update({'number of posts': tmp}).then((value) {
          postLoading = false;
          //مهممممممممممممممممممم
          //commentsCount.insert(0, 0);

          showToast(
              message: "published!", state: ToastStates.right, context: ctx);
          postImage = null;
          emit(createPostSuccessState());
          Navigator.of(ctx).pop();
        }).catchError((onError) {
          emit(createPostErrorState(onError));
          Navigator.of(ctx).pop();
        });
      });
    });

    /*  awesomeDialog(
          context: ctx,
          text: "updated Successfully",
          title: "update profile",
          dialogType: DialogType.SUCCES,
          onPressed: () async {
            await getUser(ctx);
            Navigator.of(ctx).pop();
          }); */
  }

  void editProfile({
    String? email,
    String? bio,
    String? location,
    String? username,
    String? pass,
    String? phone,
    required BuildContext ctx,
  }) async {
    editProfileLoading = true;
    emit(editProfileLoadingState());

    final storageRef = FirebaseStorage.instance.ref();

    if (profimgFile != null) {
      await storageRef
          .child(user!.getToken)
          .child("profile")
          .putFile(profimgFile!);

      profileImageUrl = await storageRef
          .child(user!.getToken)
          .child("profile")
          .getDownloadURL()
          .then((value) {
        //emit(getImageUrlSuccessState());
      }).catchError((onError) {
        //emit(getImageUrlErrorState());
      });
    }
    if (coverimgFile != null) {
      await storageRef
          .child(user!.getToken)
          .child("cover")
          .putFile(coverimgFile!);

      coverimgUrl = await storageRef
          .child(user!.getToken)
          .child("cover")
          .getDownloadURL()
          .then((value) {
        //emit(getImageUrlSuccessState());
      }).catchError((onError) {
        //emit(getImageUrlErrorState());
      });
    }
    User u = User(
      email: email!.isEmpty ? user!.email : email,
      bio: bio!.isEmpty ? user!.bio : bio,
      location: location ?? user!.getLocation,
      coverImageUrl: coverimgUrl ?? user!.coverImageUrl,
      username: username!.isEmpty ? user!.username : username,
      profileIimageUrl: profileImageUrl ?? user!.profileIimageUrl,
      phone: phone!.isEmpty ? user!.phone : phone,
      Token: user!.getToken, //ثابتين مش بغيرهم
    );
    updateUser(u, ctx);
  }

  void updateUser(
    User user,
    BuildContext ctx,
  ) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uID)
        .update(user.toMap())
        .then((value) {
      /* showToast(
        
          message: "Registered Successfully",
          state: ToastStates.right,
          context: ctx); */
      editProfileLoading = false;

      //emit(editProfileSuccessState());
      awesomeDialog(
          context: ctx,
          text: "updated Successfully",
          title: "update profile",
          dialogType: DialogType.SUCCES,
          onPressed: () async {
            await getUser(ctx);
            Navigator.of(ctx).pop();
          });
    }).catchError((onError) {
      editProfileLoading = false;
      showToast(
          message: onError.toString(), state: ToastStates.error, context: ctx);

      emit(editProfileErrorState(onError));
    });
  }

  removePostImage() {
    postImage = null;
    emit(removePostImageState());
  }

  removeMessagetImage() {
    messageImg = null;
    emit(removeMessageImageState());
  }

  removeCommentImage() {
    commentImage = null;
    //commentImageUrl="";
    emit(removeCommentImageState());
  }

  pickImage(
      {required ImageSource source,
      required BuildContext ctx,
      required bool profile,
      bool? comment,
      bool? video,
      bool? message,
      bool? post}) async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = video != null
        ? await _picker
            .pickVideo(
            source: source,
          )
            .catchError((onError) {
            emit(pickedImageErrorState(onError.toString()));
          })
        : await _picker
            .pickImage(source: source, imageQuality: 85)
            .catchError((onError) {
            emit(pickedImageErrorState(onError.toString()));
          });
    if (post == null) {
      if (comment == null) {
        if (profile && image != null) {
          profimgFile = File(
            image.path,
          );
          emit(pickedImageSuccessState());
        } else if (!profile && image != null) {
          if (message != null) {
            messageImg = File(image.path);
          } else {
            coverimgFile = File(image.path);
          }
          emit(pickedImageSuccessState());
        }
      }
      //commnet
      else {
        if (image != null) {
          commentImage = File(image.path);
          emit(pickedCommentImageSuccessState());
        }
      }
    }
    //post
    else {
      if (image != null) {
        postImage = File(image.path);
        emit(pickedPostImageSuccessState());
      }
    }

    Navigator.of(ctx).pop();
  }

  List<Widget> screens = const [
    feedsScreen(),
    chatsScreen(),
    usersScreen(),
    settingsScreen(),
  ];
  List<bool> selected = [
    false,
    false,
    false,
    false,
  ];
  List<String> titles = const [
    "Home",
    "chats",
    "users",
    "profile",
  ];
  int currentIndex = 0;
  changeNavIndex(int index) {
    currentIndex = index;
    emit(changeNavIndexState());
  }

  checkPostFormLength(strPost) {
    post = strPost;
    emit(PostFormLengthChangedState());
  }

  getUser(BuildContext context) {
    emit(socialGetDataLoadingState());
    FirebaseFirestore.instance.collection('users').get().then((value) async {
      for (var element in value.docs) {
        users.addAll({element.id: User.fromJson(element.data())});
        //هاتني
        user = users[uID];
      }
      await getChatMessages();

      getPosts();
    });
  }

  int TotalComments = 0;
  //get Posts
  getPosts() {
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('time', descending: true)
        .get()
        .then(
      (value) async {
        if (value.docs.isNotEmpty) {
          for (var doc in value.docs) {
            TotalComments = 0;
            bool mine = doc.data()['uID'] == user!.getToken;

            if (user!.following.contains(doc.data()['uID']) || mine) {
              posts.add(Post.fromJson(doc.data())..setPostUID(doc.id));

              /* to be back
              QuerySnapshot<Map<String, dynamic>>? c =
                  await doc.reference.collection('comments').get();
              if (c.docs.length - 1 != 0) {
                //لازم تبقي هنا مش الي تحت..تحت المفروض بتلف ع كل الكومنتس الي تحت نفس البوست فمينفعش تمسح عشان تقدر تضيف كذا كومنت لنفس البوست
                tmpCommentsModel = [];
                TotalComments = c.docs.length - 1;

                print('-_-');
                for (var commentElement in c.docs) {
                  if (commentElement.id != 'test') {
                    /*  tmpCommentsModel
                          .add(CommentsModel.fromJson(commentElement.data()));
 */

                    //for each comment in single post
                    QuerySnapshot<Map<String, dynamic>>? repDocs =
                        await commentElement.reference
                            .collection('replies')
                            .get();
                    if (repDocs.docs.length - 1 != 0) {
                      //important
                      tmpReplyModel = [];

                      TotalComments += repDocs.docs.length - 1;
                      for (var r in repDocs.docs) {
                        if (r.id != 'test') {
                          //مهم حدا ال set
                          tmpReplyModel.add(CommentsModel.fromJson(r.data())
                            ..setCommentUid(r.id));
                        }
                      }
                      //لما يخلص ملي الريبلاي حط الكومنت مره واحده
                      tmpCommentsModel.add(
                        CommentsModel.fromJson(
                          commentElement.data(),
                        )
                          ..setReplies(tmpReplyModel)
                          ..setCommentUid(commentElement.id),
                      );
                    }
                    //no reply then make normal comment model
                    else {
                      tmpCommentsModel.add(
                        CommentsModel.fromJson(
                          commentElement.data(),
                        )..setCommentUid(commentElement.id),
                      );
                    }
                    posts[currentPostIndex].setTotalComments(TotalComments);
                    posts[currentPostIndex].setComments(tmpCommentsModel);
                  }
                }
              }
              // no comment

              */

            }
            //others posts

          }

          emit(socialGetDataSuccessState());
        }
        //no posts
        else {
          emit(socialGetDataSuccessState());
        }
      },
    );
  }

  List<Message> chatMessages = [];

  getChatMessages() async {
    QuerySnapshot<Map<String, dynamic>>? chats = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(uID)
        .collection('chats')
        .orderBy('time')
        .get();
    if (chats.docs.isNotEmpty) {
      for (var c in chats.docs) {
        chatMessages.add(Message.fromJson(c.data()));
      }
    }
    print('done ${chatMessages.length}');
  }

  getComments(String postUid, int postIndex) {
    //for each post

    emit(socialGetDataLoadingState());

    FirebaseFirestore.instance
        .collection('posts')
        .doc(postUid)
        .get()
        .then((value) async {
      QuerySnapshot<Map<String, dynamic>>? c =
          await value.reference.collection('comments').get();
      if (c.docs.length - 1 != 0) {
        print('feeeee comm');
        //لازم تبقي هنا مش الي تحت..تحت المفروض بتلف ع كل الكومنتس الي تحت نفس البوست فمينفعش تمسح عشان تقدر تضيف كذا كومنت لنفس البوست
        tmpCommentsModel = [];

        print('-_-');
        for (var commentElement in c.docs) {
          if (commentElement.id != 'test') {
            /*  tmpCommentsModel
                          .add(CommentsModel.fromJson(commentElement.data()));
 */

            //for each comment in single post
            QuerySnapshot<Map<String, dynamic>>? repDocs =
                await commentElement.reference.collection('replies').get();
            if (repDocs.docs.length - 1 != 0) {
              //important
              tmpReplyModel = [];

              for (var r in repDocs.docs) {
                if (r.id != 'test') {
                  //مهم حدا ال set
                  tmpReplyModel.add(
                      CommentsModel.fromJson(r.data())..setCommentUid(r.id));
                }
              }
              //لما يخلص ملي الريبلاي حط الكومنت مره واحده
              tmpCommentsModel.add(
                CommentsModel.fromJson(
                  commentElement.data(),
                )
                  ..setReplies(tmpReplyModel)
                  ..setCommentUid(commentElement.id),
              );
            }
            //no reply then make normal comment model
            else {
              tmpCommentsModel.add(
                CommentsModel.fromJson(
                  commentElement.data(),
                )..setCommentUid(commentElement.id),
              );
            }
            print('alllllllllllllllll');
            posts[postIndex].setComments(tmpCommentsModel);
          }
        }
      }
      // no comment
      emit(socialGetDataSuccessState());
    });
  }
  /* .catchError((onError) {
        print(onError.toString());

        awesomeDialog(
            context: context,
            text: "Error getting data",
            title: "Error",
            dialogType: DialogType.ERROR);
        emit(socialGetDataErrorState(onError.toString()));
      });
    });  .catchError((onError) {
      awesomeDialog(
          context: context,
          text: "Error getting data",
          title: "Error",
          dialogType: DialogType.ERROR);
      emit(socialGetDataErrorState(onError.toString()));
    }); */
  //user=doc.data();

  addComment(
      {required String text,
      required String postUid,
      required int currentPostIndex}) async {
    if (commentImage != null) {
      final storageRef = FirebaseStorage.instance.ref();
      print('eeeh');

      await storageRef
          .child("comments")
          .child(Uri.file(commentImage!.path).pathSegments.last)
          .putFile(commentImage!);
      commentImageUrl = await storageRef
          .child("comments")
          .child(Uri.file(commentImage!.path).pathSegments.last)
          .getDownloadURL();
    }
    //مهم

    CommentsModel model = CommentsModel(
      now: Timestamp.now(),
      profileImageUrl: user!.profileIimageUrl!,
      uID: user!.getToken,
      username: user!.username,
      commentIimageUrl: commentImageUrl ?? '',

      comment: text,
      //likes: 0
    );

    FirebaseFirestore.instance
        .collection('posts')
        .doc(postUid)
        .collection('comments')
        .add(model.toMap())
        .then((value) async {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postUid)
          .get()
          .then((value) async {
        int totalComments = value.data()!['total comments'];
        totalComments += 1;
        FirebaseFirestore.instance
            .collection('posts')
            .doc(postUid)
            .update({'total comments': totalComments}).then((value) {});
      });

      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postUid)
          .collection('comments')
          .doc(value.id)
          .collection('replies')
          .doc('test')
          .set({});

      tmpCommentsModel = [];

      if (posts[currentPostIndex].comments.isNotEmpty) {
        posts[currentPostIndex].comments.add(CommentsModel.fromJson(
              model.toMap(),
            )..setCommentUid(value.id));
      } else {
        tmpCommentsModel = [];
        tmpCommentsModel.add(CommentsModel.fromJson(
          model.toMap(),
        )..setCommentUid(value.id));

        posts[currentPostIndex].setComments(tmpCommentsModel);
      }
      int tmp = posts[currentPostIndex].TotalComments;
      tmp += 1;
      posts[currentPostIndex].setTotalComments(tmp);

      //mohem
      commentImage = null;
      commentImageUrl = "";
      emit(addCommentSuccessState());
    }).catchError((onError) {
      emit(addCommentErrorState(onError.toString()));
    });
  }

  commentReplySwitch(bool reply, {int? index}) {
    //isReply[index] = !isReply[index];
    replying = reply;
    // pressedReplyIndex = index ?? 0;
    emit(pressedReplyState());
  }

  addReply({
    bool? profile,
    required String text,
    required String postUid,
    required String commentUid,
    required int currentPostIndex,
    required int commentIndex,
  }) async {
    if (commentImage != null) {
      final storageRef = FirebaseStorage.instance.ref();
      await storageRef
          .child("comments")
          .child(Uri.file(commentImage!.path).pathSegments.last)
          .putFile(commentImage!);
      commentImageUrl = await storageRef
          .child("comments")
          .child(Uri.file(commentImage!.path).pathSegments.last)
          .getDownloadURL();
    }

    CommentsModel reply = CommentsModel(
      now: Timestamp.now(),
      profileImageUrl: user!.profileIimageUrl!,
      uID: user!.getToken,
      username: user!.username,
      comment: text,
      commentIimageUrl: commentImageUrl ?? '',
    );

    FirebaseFirestore.instance
        .collection('posts')
        .doc(postUid)
        .collection('comments')
        .doc(commentUid)
        .collection('replies')
        .add(reply.toMap())
        .then((value) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postUid)
          .get()
          .then((value) async {
        int totalComments = value.data()!['total comments'];
        totalComments += 1;
        FirebaseFirestore.instance
            .collection('posts')
            .doc(postUid)
            .update({'total comments': totalComments}).then((value) async {});
      });

      //reply uid
      /*  tmpReplyModel.add(CommentsModel.fromJson(
        reply.toMap(),
      )..setCommentUid(value.id)); */

      if (posts[currentPostIndex].comments[commentIndex].replies.isNotEmpty) {
        posts[currentPostIndex]
            .comments[commentIndex]
            .replies
            .add(CommentsModel.fromJson(
              reply.toMap(),
            )..setCommentUid(value.id));
      } else {
        tmpCommentsModel = [];
        tmpCommentsModel.add(CommentsModel.fromJson(
          reply.toMap(),
        )..setCommentUid(value.id));

        posts[currentPostIndex]
            .comments[commentIndex]
            .setReplies(tmpCommentsModel);
      }
      int tmp = posts[currentPostIndex].TotalComments;
      tmp += 1;
      posts[currentPostIndex].setTotalComments(tmp);

      commentImage = null;
      commentImageUrl = "";

      emit(addCommentSuccessState());
    }).catchError((onError) {
      emit(addCommentErrorState(onError.toString()));
    });
  }

  likeComment({
    required String postUid,
    required String commentUid,
    required int currentPostIndex,
    required int currentCommentIndex,
  }) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postUid)
        .collection('comments')
        .doc(commentUid)
        .get()
        .then((value) {
      List<dynamic> tmp = value.data()!['likes'];
      if (tmp.contains(user!.getToken)) {
        tmp.removeWhere((element) => element == user!.getToken);
        posts[currentPostIndex]
            .comments[currentCommentIndex]
            .likes
            .removeWhere((element) => element == user!.getToken);

        FirebaseFirestore.instance
            .collection('posts')
            .doc(postUid)
            .collection('comments')
            .doc(commentUid)
            .update({'likes': tmp}).then((value) {
          emit(dislikedPostState());
        }).catchError((onErrror) {
          emit(checkLikeErrorState(onErrror.toString()));
        });
      } else {
        tmp.add(user!.getToken);
        FirebaseFirestore.instance
            .collection('posts')
            .doc(postUid)
            .collection('comments')
            .doc(commentUid)
            .update({'likes': tmp}).then((value) {
          posts[currentPostIndex]
              .comments[currentCommentIndex]
              .likes
              .add(user!.getToken);
          emit(likedPostState());
        }).catchError((onErrror) {
          emit(checkLikeErrorState(onErrror.toString()));
        });
      }
    });
  }

  likeReply(
      {required int currentPostIndex,
      required String postUid,
      required String commentUid,
      required int commentIndex,
      required String replyUid,
      required int replyIndex}) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postUid)
        .collection('comments')
        .doc(commentUid)
        .collection('replies')
        .doc(replyUid)
        .get()
        .then((value) {
      List<dynamic> tmp = value.data()!['likes'];
      if (tmp.contains(user!.getToken)) {
        tmp.removeWhere((element) => element == user!.getToken);
        posts[currentPostIndex]
            .comments[commentIndex]
            .replies[replyIndex]
            .likes
            .removeWhere((element) => element == user!.getToken);
        FirebaseFirestore.instance
            .collection('posts')
            .doc(postUid)
            .collection('comments')
            .doc(commentUid)
            .collection('replies')
            .doc(replyUid)
            .update({'likes': tmp}).then((value) {
          emit(dislikedPostState());
        }).catchError((onErrror) {
          emit(checkLikeErrorState(onErrror.toString()));
        });
      } else {
        //for database
        tmp.add(user!.getToken);
        //for ui

        posts[currentPostIndex]
            .comments[commentIndex]
            .replies[replyIndex]
            .likes
            .add(user!.getToken);
        FirebaseFirestore.instance
            .collection('posts')
            .doc(postUid)
            .collection('comments')
            .doc(commentUid)
            .collection('replies')
            .doc(replyUid)
            .update({'likes': tmp}).then((value) {
          emit(likedPostState());
        }).catchError((onErrror) {
          emit(checkLikeErrorState(onErrror.toString()));
        });
      }
    });
  }

  followUser(String followedPerson) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.getToken)
        .get()
        .then((value) {
      List<String> tmp = value.data()!['following'].cast<String>();
      tmp.add(followedPerson);
      user!.setFollowing(tmp);

      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.getToken)
          .update({'following': tmp}).then((value) {
        emit(followSuccessState());
      });
    });
  }

  unfollowUser(String unfollowedPerson) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.getToken)
        .get()
        .then((value) {
      List<String> tmp = value.data()!['following'].cast<String>();
      tmp.removeWhere((element) => element == unfollowedPerson);
      user!.setFollowing(tmp);

      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.getToken)
          .update({'following': tmp}).then((value) {
        emit(unfollowSuccessState());
      });
    });
  }

  showRep(bool val) {
    showReplies = val;
    emit(showRepliesState());
  }

  File? messageImg;
  String? messageImgUrl;
  sendMessage({
    required String recieverId,
    String? text,
  }) async {
    var now = Timestamp.now();
    /* var model =
        ChatModel(recieverId: recieverId, time: now, lastMessage: text ?? ''); */
    if (messageImg != null) {
      final storageRef = FirebaseStorage.instance.ref();
      await storageRef
          .child("messages")
          .child(Uri.file(messageImg!.path).pathSegments.last)
          .putFile(messageImg!);
      messageImgUrl = await storageRef
          .child("messages")
          .child(Uri.file(messageImg!.path).pathSegments.last)
          .getDownloadURL();
    }
    Message message = Message(
        senderId: user!.getToken,
        time: Timestamp.now(),
        recieverId: recieverId,
        text: text ?? '',
        imgUrl: messageImgUrl ?? '');

    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.getToken)
        .collection('chats')
        .doc(recieverId)
        .set(message.toMap())
        .then((value) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.getToken)
          .collection('chats')
          .doc(recieverId)
          .collection('messages')
          .doc()
          .set(message.toMap())
          .then((value) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(recieverId)
            .collection('chats')
            .doc(user!.getToken)
            .collection('messages')
            .doc()
            .set(message.toMap())
            .then((value) {
          messageImg = null;
          if (chatMessages.any((element) => element.recieverId == recieverId)) {
            chatMessages
                .removeWhere((element) => element.recieverId == recieverId);
            chatMessages.insert(0, message);
          } else {
            chatMessages.insert(0, message);
          }
          emit(sendMessageSuccessState());
        }).catchError((onErrror) {
          emit(sendMessageErrorState(onErrror.toString()));
        });
      }).catchError((onErrror) {
        emit(sendMessageErrorState(onErrror.toString()));
      });
    });
  }

  List<Message> messages = [];

  getMessages({required String recieverId}) {
    emit(getMessageLoadingState());

    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.getToken)
        .collection('chats')
        .doc(recieverId)
        .collection('messages')
        .orderBy('time')
        .snapshots()
        .listen((event) {
      //chatMessages = [];
      messages = [];
      for (var element in event.docs) {
        messages.add(
          Message.fromJson(
            element.data(),
          ),
        );
      }
      /*  chatMessages.removeWhere((element)=>element.recieverId==recieverId);
      chatMessages.add(messages) */
      emit(getMessageSuccessState());
    });
  }

  List<String>? savedPosts;
  getSavedPost() {
emit(savedPostsLoadingState());

 FirebaseFirestore.instance
        .collection('users')
        .doc(uID)
        .get().then((value) {
        savedPosts=value.data()!['saved posts'].cast<String>();
        emit(savedPostsSuccessState());

        }).catchError((onError){
                emit(savedPostsErrorState(onError.toString()));



        });

     

  }
  
  savePost(String postUid) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uID)
        .set({'post id': postUid}).then((value) {
      savedPosts?.add(postUid);
      emit(savedPostsSuccessState());
    }).catchError((onError) {
      emit(savedPostsErrorState(onError.toString()));
    });
  }
}
