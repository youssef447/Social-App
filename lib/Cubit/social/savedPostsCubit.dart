import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/Cubit/social/savedPostsStates.dart';

import '../../models/post.dart';

class savedPosts extends Cubit<savedPostsStates>{

  savedPosts() : super(savedPostsInitialState());

  static savedPosts get (ctx)=>BlocProvider.of(ctx);
  List<Post>?saved;

  
  getSavedPosts(){




  }

}