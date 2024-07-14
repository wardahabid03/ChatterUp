import 'package:chat_with_me/modules/new_post/new_post_screen.dart';
import 'package:chat_with_me/shared/components/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../../shared/cubits/layout_cubit/cubit.dart';
import '../../shared/cubits/layout_cubit/states.dart';
import '../../shared/style/icon_broken.dart';
import '../edit_profile/edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentUser = SocialCubit.get(context).userModel; // Currently logged-in user
    var posts = SocialCubit.get(context).posts; // All posts

    // Filter posts to display only the posts of the currently logged-in user
    var userPosts = posts.where((post) => post.uId == currentUser?.uId).toList();
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel;

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    height: 190,
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: double.infinity,
                            height: 140,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                              ),
                              image: DecorationImage(
                                image: NetworkImage('${userModel!.cover}'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          radius: 64,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage('${userModel.image}'),
                          ),
                        )
                      ],
                    ),
                  ),
                  Text(
                    '${userModel.name}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    '${userModel.bio}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20), // Adjust the right margin as needed
                        child: SizedBox(
                          height: 35,
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              navigateTo(context, const NewPostScreen());
                            },
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all(Colors.purple),
                              side: MaterialStateProperty.all(
                                const BorderSide(color: Colors.purple),
                              ),
                              padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 8)),
                            ),
                            icon: const Icon(IconBroken.Image, size: 18), // Adjust the size as needed
                            label: const Text('Add Photos', style: TextStyle(fontSize: 12)), // Adjust the font size as needed
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20), // Adjust the left margin as needed
                        child: SizedBox(
                          height: 35,
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              navigateTo(context, const EditProfileScreen());
                            },
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all(Colors.purple),
                              side: MaterialStateProperty.all(
                                const BorderSide(color: Colors.purple),
                              ),
                              padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 8)),
                            ),
                            icon: const Icon(IconBroken.Edit, size: 18), // Adjust the size as needed
                            label: const Text('Edit Profile', style: TextStyle(fontSize: 12)), // Adjust the font size as needed
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Displaying posts in rows
                  for (int i = 0; i < userPosts.length; i += 3)
                    Row(
                      children: [
                        for (int j = i; j < i + 3 && j < userPosts.length; j++)
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                // Handle post tap
                              },
                              child: SizedBox(
                                height: MediaQuery.of(context).size.width / 3 - 1.5,
                                child: Image.network('${userPosts[j].postImage}', fit: BoxFit.cover),
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
