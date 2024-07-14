import 'dart:async';
import 'dart:io';

import 'package:chat_with_me/shared/cubits/layout_cubit/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storge;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';

import '../../../models/message_model/message_model.dart';
import '../../../models/comment_model/comment_model.dart';
import '../../../models/post_model/post_model.dart';
import '../../../models/social_user_model/social_user_model.dart';
import '../../../modules/chats/user_chats_screen/User_chats_screen.dart';
import '../../../modules/feeds/feeds_screen.dart';
import '../../../modules/login_screen/login_screen.dart';
import '../../../modules/new_post/new_post_screen.dart';
import '../../../modules/profile/profile_screen.dart';
// import '../../../modules/users/users_screen.dart';
import '../../components/components.dart';
import '../../components/constants.dart';
import '../../network/local/cache_helper.dart';
import 'package:audioplayers/audioplayers.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  SocialUserModel? userModel;

  // get user data and initial user model
  getUserData() {
    emit(SocialGetUserLoadingState());
print(",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,");
print(userUId);
    FirebaseFirestore.instance
        .collection('users')
        .doc(userUId)
        .get()
        .then((value) {
      userModel = SocialUserModel.fromJson(value.data()!);
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      print(userModel);
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      print('getUserData error : $error');
      emit(SocialGetUserErrorState(error: error));
    });
  }

  int currentIndex = 0;

  //pages
  List screens = [
    const FeedsScreen(),
    const UserChatsScreen(),
    const NewPostScreen(),
    // const UsersScreen(),
    const ProfileScreen(),
  ];

  // pages appbar title
  // List titles = [
  //   'assets/images/ChatterUp.png',
  //   'assets/images/ChatterUp.png',
  //   'assets/images/ChatterUp.png',
  //   'assets/images/ChatterUp.png',
  //   'assets/images/ChatterUp.png',
  // ];

  //Navigate between pages
  changeBottomNav(int index) {
    if (index == 1) getUsers();
    if (index == 2) {
      emit(SocialNewPostState());
    } else {
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    }
  }

  // get profile image from gallery
  File? profileImage;
  var profileImagePicker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile =
        await profileImagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      print('No Image Selected');
      emit(SocialProfileImagePickedErrorState());
    }
  }

  // upload profile image on server
  String? profileImageUrl;

  Future<void> uploadProfileImage() async {
    print("profile image : $profileImage");
    await firebase_storge.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) async {
      // get url of picture

      await value.ref.getDownloadURL().then((urlValue) {
        emit(SocialUploadProfileImageSuccessState());
        profileImageUrl = urlValue;
      }).catchError((error) {
        print('error from profile get url image $error');
        emit(SocialUploadProfileImageErrorState());
      });
    }).catchError((error) {
      print('error from profile upload image $error');
      emit(SocialUploadProfileImageErrorState());
    });
  }

  // get cover image from gallery
  File? coverImage;
  var coverImagePicker = ImagePicker();

  Future<void> getCoverImage() async {
    final pickedFile =
        await coverImagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImagePickedSuccessState());
    } else {
      print('No Image Selected');
      emit(SocialCoverImagePickedErrorState());
    }
  }

  // upload cover image on server
  String? coverImageUrl;

  Future<void> uploadCoverImage() async {
    await firebase_storge.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) async {
      // get url of picture
      await value.ref.getDownloadURL().then((urlValue) {
        emit(SocialUploadCoverImageSuccessState());
        coverImageUrl = urlValue;
      }).catchError((error) {
        print('error from profile get url image $error');
        emit(SocialUploadCoverImageErrorState());
      });
    }).catchError((error) {
      print('error from profile upload image $error');
      emit(SocialUploadCoverImageErrorState());
    });
  }

  //upload cover and profile images on server
  uploadUserImages() async {
    if (coverImage != null) await uploadCoverImage();
    if (profileImage != null) await uploadProfileImage();
  }

  // update user profile
  updateUserData({
    String? name,
    String? bio,
    String? phone,
  }) async {
    emit(SocialUserUpdateLoadingState());
    //upload profile and cover images on firestorge
    await uploadUserImages();
    // update user data on firebasa
    FirebaseFirestore.instance.collection('users').doc(userModel!.uId).update({
      'name': name,
      'phone': phone,
      'bio': bio,
      'image': profileImageUrl ?? userModel!.image,
      'cover': coverImageUrl ?? userModel!.cover,
    }).then((value) {
      getUserData();
    }).catchError((error) {
      print('error from update data $error');
      emit(SocialUserUpdateErrorState());
    });
  }

  // get post image from gallery
  File? postImage;
  var postImagePicker = ImagePicker();

  Future<void> getPostImage() async {
    final pickedFile =
        await postImagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    } else {
      print('No Image Selected');
      emit(SocialPostImagePickedErrorState());
    }
  }

  // remove image from post
  removeImageFromPost() {
    postImage = null;
    emit(SocialRemovePostImageState());
  }
//create post with image
createNewPostWithImage({
  required String dateTime,
  required String text,
  List<String>? tags, // Add tags parameter
}) {
  firebase_storge.FirebaseStorage.instance
      .ref()
      .child('users/${Uri.file(postImage!.path).pathSegments.last}')
      .putFile(postImage!)
      .then((value) {
    // get url of picture
    value.ref.getDownloadURL().then((urlValue) {
      createNewPost(
        dateTime: dateTime,
        text: text,
        postImage: urlValue,
        tags: tags, // Pass tags to createNewPost method
      );
    }).catchError((error) {
      print('error from profile get url image $error');
      emit(SocialCreatePostErrorState());
    });
  }).catchError((error) {
    print('error from profile upload image $error');
    emit(SocialCreatePostErrorState());
  });
}

//create post without image
createNewPost({
  required String dateTime,
  required String text,
  String? postImage,
  List<String>? tags, // Add tags parameter
}) {
  emit(SocialCreatePostLoadingState());

  PostModel model = PostModel(
    name: userModel!.name,
    image: userModel!.image,
    uId: userModel!.uId,
    postImage: postImage ?? '',
    text: text,
    dateTime: dateTime,
    tags: tags, // Include tags in PostModel initialization
  );

  FirebaseFirestore.instance
      .collection('posts')
      .add(model.toMap())
      .then((value) {
    emit(SocialCreatePostSuccessState());
    getPosts();
  }).catchError((error) {
    print('error from update data $error');
    emit(SocialCreatePostErrorState());
  });
}

  //get posts from server
  List<PostModel> posts = [];
  List<String> postIdList = [];
  List<int> likes = [];

  List userLikedID = [];
  Map<String, List> postLikesID = {};

  getPosts() {
  emit(SocialGetPostsLoadingState());
  FirebaseFirestore.instance.collection('posts').get().then((value) async {
    for (var postElement in value.docs) {
      // Retrieve post data including tags
      Map<String, dynamic> postData = postElement.data();
      // Convert list of tags from Firestore to a List<String>
      List<String>? tags = postData['tags'] != null
          ? List<String>.from(postData['tags'])
          : null;

      // Create a PostModel object with retrieved data
      PostModel postModel = PostModel.fromJson(postData);

      // Retrieve post likes
      await postElement.reference.collection('likes').get().then((postLikes) {
        // Add post likes length to likes list
        likes.add(postLikes.docs.length);

        // Add user IDs who liked the post to userLikedID list
        List<String> likedIDs = postLikes.docs.map((doc) => doc.id).toList();
        userLikedID.addAll(likedIDs);

        // Map post ID to list of user IDs who liked the post
        postLikesID[postElement.id] = likedIDs;
      }).catchError((error) {
        print('Error fetching likes: $error');
      });

      // Add the post to the posts list
      posts.add(postModel);

      // Add the post ID to the postIdList
      postIdList.add(postElement.id);
    }
    emit(SocialGetPostsSuccessState());
  }).catchError((error) {
    print('Error getting posts: $error');
    emit(SocialGetPostsErrorState(error: error.toString()));
  });
}

  bool isLiked(String postId) {
    return postLikesID[postId]!.contains(userModel!.uId);
  }

  //post likes
  likePost(String postId, int index) {
    if (postLikesID[postId]!.contains(userModel!.uId)) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(userModel!.uId)
          .delete()
          .then((value) {
        updateLikesCount(postId, index);
        emit(SocialPostLikesSuccessState());
      }).catchError((error) {
        emit(SocialPostLikesErrorState(error: error));
      });
    } else {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(userModel!.uId)
          .set({
        'like': true,
      }).then((value) {
        updateLikesCount(postId, index);
        emit(SocialPostLikesSuccessState());
      }).catchError((error) {
        emit(SocialPostLikesErrorState(error: error));
      });
    }
  }

  //update post likes
  updateLikesCount(String postId, int index) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .get()
        .then((valueLikes) {
      likes[index] = valueLikes.docs.length;
      for (var e in valueLikes.docs) {
        userLikedID.add(e.id);
      }
      postLikesID[postId] = [...userLikedID];
      userLikedID.clear();
      emit(SocialUpdatePostLikesSuccessState());
    }).catchError((error) {
      emit(SocialUpdateLikesErrorState(error: error));
    });
  }

//post comment
// Add comment to a post
addCommentToPost(String postId, CommentModel comment) {
  FirebaseFirestore.instance
      .collection('posts')
      .doc(postId)
      .collection('comments')
      .add(comment.toMap())
      .then((value) {
    // Update local post model with the new comment
    for (var post in posts) {
      if (post.uId == postId) {
        if (post.comments == null) {
          post.comments = [comment];
        } else {
          post.comments!.add(comment);
        }
        break;
      }
    }
    emit(SocialPostCommentsSuccessState());
    // Optionally, fetch comments for the post after adding a new comment
     getCommentsForPost(postId);
  }).catchError((error) {
    emit(SocialPostCommentsErrorState(error: error));
  });
}

// Get comments for a post
getCommentsForPost(String postId) {
  print("Fetching comments for post $postId...");
  FirebaseFirestore.instance
      .collection('posts')
      .doc(postId)
      .collection('comments')
      .snapshots()
      .listen((commentsSnapshot) {
    // Convert each comment document to a CommentModel object
    List<CommentModel> comments = commentsSnapshot.docs
        .map((commentDoc) => CommentModel.fromJson(commentDoc.data()))
        .toList();

    if (comments.isNotEmpty) {
      print("Comments fetched successfully: $comments");

      // Update local post model with the comments
      bool postFound = false;
      for (var post in posts) {
        if (true) {
          post.comments = comments;
          postFound = true;
          print("Comments updated for post $postId");
          break;
        }
      }

      if (!postFound) {
        print("Post not found with ID: $postId");
      }
    } else {
      print("No comments found for post $postId");
    }

    emit(SocialPostCommentsSuccessState());
  }, onError: (error) {
    print("Error fetching comments for post $postId: $error");
    emit(SocialPostCommentsErrorState(error: error.toString()));
  });
}



// postComment(
//     {required String postId, required String comment, required int index}) {
//   FirebaseFirestore.instance
//       .collection('posts')
//       .doc(postId)
//       .collection('comments')
//       .doc(userModel!.uId)
//       .set({
//     'comment': comment,
//   }).then((value) {
//     updateCommentCount(postId, index);
//     emit(SocialPostCommentsSuccessState());
//   }).catchError((error) {
//     emit(SocialPostCommentsErrorState(error: error));
//   });
// }
//
// //update post comment
// updateCommentCount(String postId, int index) {
//   FirebaseFirestore.instance
//       .collection('posts')
//       .doc(postId)
//       .collection('comments')
//       .get()
//       .then((valueComments) {
//     // comments[index] = valueComments.docs.length;
//     emit(SocialUpdatePostLikesSuccessState());
//   }).catchError((error) {
//     emit(SocialUpdateLikesErrorState(error: error));
//   });
// }

  //get all users in chat
  List<SocialUserModel> users = [];

  getUsers() {
    emit(SocialGetAllUsersLoadingState());
    users = [];
    FirebaseFirestore.instance.collection('users').get().then((value) async {
      for (var postElement in value.docs) {
        if (postElement.data()['uId'] != userModel!.uId) {
          users.add(SocialUserModel.fromJson(postElement.data()));
        }
      }

      emit(SocialGetAllUsersSuccessState());
    }).catchError((error) {
      print(error);
      emit(SocialGetAllUsersErrorState(error: error.toString()));
    });
  }

  //user sign out
  signout(context) {
    emit(SocialUserSignoutLoadingState());
    FirebaseAuth.instance.signOut().then((value) {
      SocialacheHelper.sharedPreferences.clear();
      userUId = '';
      currentIndex = 0;
      navigateTo(context, const LoginScreen(), backOrNo: false);
      emit(SocialUserSignoutSuccessState());
    }).catchError((error) {
      emit(SocialUserSignoutErrorState(error: error));
    });
  }


String? downloadUrl;

  // import 'package:firebase_storage/firebase_storage.dart';

// Retrieve the URL of the audio file from Firebase Storage
Future<void> getAudioFileUrl(String audioFilePath) async {
  try {

    print("Audio file path string: $audioFilePath");
    // Create a Firebase Storage reference to the audio file
   File audioFile = File(audioFilePath);
  await firebase_storge.FirebaseStorage.instance
  .ref()
  .child('audio/${Uri.file(audioFile.path).pathSegments.last}')
  .putFile(audioFile)
  .then((value)async{


  await value.ref.getDownloadURL().then((urlValue){

    print("urlValue: $urlValue");
    downloadUrl=urlValue;
  print("audio path download url: $downloadUrl");

  //  return downloadUrl;

   

    });
  });


    // print("Audio Ref : $audioRef");

    // Get the download URL for the audio file
    // String downloadUrl = await audioRef.getDownloadURL();
  //  return downloadUrl;
  } catch (e) {
    // Handle any errors
    print('Error getting audio file URL: $e');
    // return ''; // Return an empty string or handle the error appropriately
  }
}


  //chat
  sendMessage({
  required String receiverId,
  required String dateTime,
  String? text,
  String? audioPath,
}) async {
  // Check if audioPath is provided and retrieve the download URL
  String? audioUrl;
  if (audioPath != null) {

    print("at first : $audioPath");
    await getAudioFileUrl(audioPath);

    print("2. Download Url : $audioUrl");
  }

  MessageModel model = MessageModel(
    senderId: userModel!.uId,
    receiverId: receiverId,
    dateTime: dateTime,
    text: text,
    audioPath: downloadUrl, // Use the download URL instead of the local path
  );
    //save data for my
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState(error: error));
    });
    //save data for receiver
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chat')
        .doc(userModel!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState(error: error));
    });
  }

//   //get messages
//   List<MessageModel> messages = [];

//   getmessages({
//     required String receiverId,
//   }) {
//     FirebaseFirestore.instance
//         .collection('users')
//         .doc(userModel!.uId)
//         .collection('chat')
//         .doc(receiverId)
//         .collection('messages')
//         .orderBy('dateTime') // رتيب الرسايل
//         .snapshots()
//         .listen((event) {
//       messages = [];
//       for (var element in event.docs) {
//         messages.add(MessageModel.fromJson(element.data()));
//       }
//       emit(SocialGetMessagesSuccessState());
//     });
//   }
// }


 List<MessageModel> messages = [];

getmessages({
  required String receiverId,
}) {
  FirebaseFirestore.instance
      .collection('users')
      .doc(userModel!.uId)
      .collection('chat')
      .doc(receiverId)
      .collection('messages')
      .orderBy('dateTime')
      .snapshots()
      .listen((event) async {
          messages = [];
for (var doc in event.docs) {
      var messageData = doc.data();
      final message = MessageModel.fromJson(messageData);
      // Check if the message has an audio file
      if (message.audioPath != null) {
        // Retrieve the download URL for the audio file
        // String audioUrl = await getAudioFileUrl(message.audioPath!);
        // Update the message's audioPath with the download URL
        // message.audioPath = audioUrl;
        print("audiomessage: ${message.audioPath}");
      }
      print("message: $message");
      
      messages.add(message);
    }
    emit(SocialGetMessagesSuccessState());
  });
}
}


