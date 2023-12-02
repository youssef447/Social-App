abstract class socialStates {}

class socialInitialState extends socialStates {}

class socialGetDataLoadingState extends socialStates {}

class changeNavIndexState extends socialStates {}

class savedPostsLoadingState extends socialStates {}

class savedPostsSuccessState extends socialStates {}

class savedPostsErrorState extends socialStates {
  final String error;
  savedPostsErrorState(this.error);
}

class changeRadioValueState extends socialStates {}

class changeThemeModeState extends socialStates {}

class PostFormLengthChangedState extends socialStates {}

class removePostImageState extends socialStates {}

class showRepliesState extends socialStates {}

class searchUserSuccessState extends socialStates {}

class getMessageSuccessState extends socialStates {}

class getMessageLoadingState extends socialStates {}

class removeMessageImageState extends socialStates {}

class searchUserErrorState extends socialStates {
  final String error;
  searchUserErrorState(this.error);
}

class sendMessageSuccessState extends socialStates {}

class sendMessageErrorState extends socialStates {
  final String error;
  sendMessageErrorState(this.error);
}

class removeCommentImageState extends socialStates {}

class followSuccessState extends socialStates {}

class unfollowSuccessState extends socialStates {}

class pickedCommentImageSuccessState extends socialStates {}

class socialGetDataSuccessState extends socialStates {}

class editProfileSuccessState extends socialStates {}

class editProfileLoadingState extends socialStates {}

class editProfileErrorState extends socialStates {
  final String error;
  editProfileErrorState(this.error);
}

class pickedImageErrorState extends socialStates {
  final String error;
  pickedImageErrorState(this.error);
}

class pickedImageSuccessState extends socialStates {}

class socialGetDataErrorState extends socialStates {
  final String error;

  socialGetDataErrorState(this.error);
}

class dislikedPostState extends socialStates {}

class likedPostState extends socialStates {}

class socialSuccessState extends socialStates {
  /*  final Emp socialModel;

  socialSuccessState(this.socialModel); */
}

class socialGetDataError extends socialStates {
  final String error;

  socialGetDataError(this.error);
}

class checkLikeErrorState extends socialStates {
  final String error;

  checkLikeErrorState(this.error);
}

class addCommentErrorState extends socialStates {
  final String error;

  addCommentErrorState(this.error);
}

class pressedReplyState extends socialStates {}

class likedCommentState extends socialStates {}

class addCommentSuccessState extends socialStates {}

class createPostLoadingState extends socialStates {}

class createPostSuccessState extends socialStates {}

class pickedPostImageSuccessState extends socialStates {}

class createPostErrorState extends socialStates {
  final String error;

  createPostErrorState(this.error);
}
