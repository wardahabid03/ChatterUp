import 'package:chat_with_me/shared/style/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../modules/new_post/new_post_screen.dart';
import '../../shared/components/components.dart';
import '../../shared/cubits/layout_cubit/cubit.dart';
import '../../shared/cubits/layout_cubit/states.dart';

class SocialLayout extends StatefulWidget {
  const SocialLayout({super.key});

  @override
  State<SocialLayout> createState() => _SocialLayoutState();
}

class _SocialLayoutState extends State<SocialLayout> {
  @override
  void initState() {
    context.read<SocialCubit>().getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is SocialGetUserSuccessState) {
          SocialCubit.get(context).getPosts();
        }
        if (state is SocialNewPostState) {
          navigateTo(context, const NewPostScreen());
        }
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
            title: Image.asset('assets/images/ChatterUp.png'),
            actions: [
              IconButton(
                  onPressed: () {}, icon: const Icon(IconBroken.Notification)),
              IconButton(onPressed: () {}, icon: const Icon(IconBroken.Search)),
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: const Text('Are you sure to signout ?'),
                              content: Padding(
                                padding: const EdgeInsetsDirectional.symmetric(
                                    vertical: 10),
                                child: Row(
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel')),
                                    const Spacer(),
                                    TextButton(
                                        onPressed: () {
                                          cubit.signout(context);
                                        },
                                        child: const Text('Signout')),
                                  ],
                                ),
                              ),
                            ));
                  },
                  icon: const Icon(IconBroken.Logout)),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index) => cubit.changeBottomNav(index),
            items: const [
              BottomNavigationBarItem(
                label: 'Home',
                icon: Icon(IconBroken.Home),
              ),
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Chat), label: 'Chats'),
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Upload), label: 'Post'),
              // BottomNavigationBarItem(
              //     icon: Icon(IconBroken.Location), label: 'Users'),
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Setting), label: 'Profile'),
            ],
          ),
        );
      },
    );
  }
}
// verify email
/*
ConditionalBuilder(
              condition: SocialCubit.get(context).model != null,
              builder: (context) {
                var model = SocialCubit.get(context).model;
                return Column(
                  children: [
                    // verifeid emial
                    // if (!model!.isEmailVerified!)
                    //   Container(
                    //     color: Colors.amber.withOpacity(.6),
                    //     child: Padding(
                    //       padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    //       child: Row(
                    //         children: [
                    //           const Icon(Icons.warning_rounded),
                    //           const SizedBox(width: 20),
                    //           const Expanded(
                    //             child: Text(
                    //               'please verify your email',
                    //               style: TextStyle(
                    //                 fontWeight: FontWeight.bold,
                    //               ),
                    //             ),
                    //           ),
                    //           const SizedBox(width: 20),
                    //           defaultTextButton(
                    //             onPress: () {
                    //               FirebaseAuth.instance.currentUser!
                    //                   .sendEmailVerification()
                    //                   .then((value) {
                    //                 showToast(
                    //                     text: 'check your mail',
                    //                     state: ToastStates.succes);
                    //               }).catchError((error) {});
                    //             },
                    //             text: 'send',
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                  ],
                );
              },
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
            )*/
