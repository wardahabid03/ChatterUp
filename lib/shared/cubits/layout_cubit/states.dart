abstract class SocialStates {}

class SocialInitialState extends SocialStates {}

// get user data
class SocialGetUserLoadingState extends SocialStates {}

class SocialGetUserSuccessState extends SocialStates {}

class SocialGetUserErrorState extends SocialStates {
  final String error;

  SocialGetUserErrorState({required this.error});
}

// get All user
class SocialGetAllUsersLoadingState extends SocialStates {}

class SocialGetAllUsersSuccessState extends SocialStates {}

class SocialGetAllUsersErrorState extends SocialStates {
  final String error;

  SocialGetAllUsersErrorState({required this.error});
}

//
class SocialChangeBottomNavState extends SocialStates {}

class SocialNewPostState extends SocialStates {}

//picked profile image from gallery
class SocialProfileImagePickedSuccessState extends SocialStates {}

class SocialProfileImagePickedErrorState extends SocialStates {}

//picked cover image from gallery
class SocialCoverImagePickedSuccessState extends SocialStates {}

class SocialCoverImagePickedErrorState extends SocialStates {}

//upload profile image
class SocialUploadProfileImageSuccessState extends SocialStates {}

class SocialUploadProfileImageErrorState extends SocialStates {}

//upload cover image
class SocialUploadCoverImageSuccessState extends SocialStates {}

class SocialUploadCoverImageErrorState extends SocialStates {}

//update user data
class SocialUserUpdateLoadingState extends SocialStates {}

class SocialUserUpdateErrorState extends SocialStates {}

//create post
class SocialCreatePostLoadingState extends SocialStates {}

class SocialCreatePostErrorState extends SocialStates {}

class SocialCreatePostSuccessState extends SocialStates {}

//picked post image
class SocialPostImagePickedSuccessState extends SocialStates {}

class SocialPostImagePickedErrorState extends SocialStates {}

// remove image
class SocialRemovePostImageState extends SocialStates {}

//get posts
class SocialGetPostsLoadingState extends SocialStates {}

class SocialGetPostsSuccessState extends SocialStates {}

class SocialGetPostsErrorState extends SocialStates {
  final String error;

  SocialGetPostsErrorState({required this.error});
}

// post likes
class SocialPostLikesSuccessState extends SocialStates {}

class SocialPostLikesErrorState extends SocialStates {
  final String error;

  SocialPostLikesErrorState({required this.error});
}

//post likes count
class SocialUpdatePostLikesSuccessState extends SocialStates {}

class SocialUpdateLikesErrorState extends SocialStates {
  final String error;

  SocialUpdateLikesErrorState({required this.error});
}

// post comments
class SocialPostCommentsSuccessState extends SocialStates {}

class SocialPostCommentsErrorState extends SocialStates {
  final String error;

  SocialPostCommentsErrorState({required this.error});
}

// user signout
class SocialUserSignoutLoadingState extends SocialStates {}

class SocialUserSignoutSuccessState extends SocialStates {}

class SocialUserSignoutErrorState extends SocialStates {
  final String error;

  SocialUserSignoutErrorState({required this.error});
}

// chat message
class SocialSendMessageSuccessState extends SocialStates {}

class SocialSendMessageErrorState extends SocialStates {
  final String error;

  SocialSendMessageErrorState({required this.error});
}

class SocialGetMessagesSuccessState extends SocialStates {}
