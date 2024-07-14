import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/cubits/layout_cubit/cubit.dart';
import '../../shared/cubits/layout_cubit/states.dart';
import '../../shared/style/icon_broken.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var nameControlor = TextEditingController();
  var bioControlor = TextEditingController();
  var phoneControlor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel;
        File? profileImage = SocialCubit.get(context).profileImage;
        File? coverImage = SocialCubit.get(context).coverImage;

        nameControlor.text = userModel!.name!;
        bioControlor.text = userModel.bio!;
        phoneControlor.text = userModel.phone!;

        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            // title: Image.asset('assets/images/chatterup_logo.png'),
            actions: [
              defaultTextButton(
                text: 'Update',
                onPress: () {
                  SocialCubit.get(context).updateUserData(
                    name: nameControlor.text,
                    bio: bioControlor.text,
                    phone: phoneControlor.text,
                  );
                },
              ),
              const SizedBox(width: 15),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  if (state is SocialUserUpdateLoadingState)
                    const LinearProgressIndicator(),
                  if (state is SocialUserUpdateLoadingState)
                    const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    height: 190,
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 140,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(4),
                                  ),
                                  image: DecorationImage(
                                    image: coverImage == null
                                        ? NetworkImage('${userModel.cover}')
                                            as ImageProvider
                                        : FileImage(coverImage),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    SocialCubit.get(context).getCoverImage();
                                  },
                                  icon: const CircleAvatar(
                                      radius: 15,
                                      backgroundColor: defaultColor,
                                      foregroundColor: Colors.white,
                                      child: Icon(
                                        IconBroken.Camera,
                                        size: 20,
                                      ))),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              radius: 64,
                              child: CircleAvatar(
                                radius: 60,
                                backgroundImage: profileImage == null
                                    ? NetworkImage('${userModel.image}')
                                        as ImageProvider
                                    : FileImage(profileImage),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  SocialCubit.get(context).getProfileImage();
                                },
                                icon: const CircleAvatar(
                                    radius: 15,
                                    backgroundColor: defaultColor,
                                    foregroundColor: Colors.white,
                                    child: Icon(
                                      IconBroken.Camera,
                                      size: 20,
                                    ))),
                          ],
                        )
                      ],
                    ),
                  ),
                  defaultFormFeild(
                    controller: nameControlor,
                    inputType: TextInputType.text,
                    labelText: 'Full Name',
                    prefixIcon: IconBroken.User,
                    validat: (String? value) {
                      if (value!.isEmpty) {
                        return 'name must be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  defaultFormFeild(
                    controller: bioControlor,
                    inputType: TextInputType.text,
                    labelText: 'Bio',
                    prefixIcon: IconBroken.Info_Circle,
                    validat: (String? value) {
                      if (value!.isEmpty) {
                        return 'bio must be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  defaultFormFeild(
                    controller: phoneControlor,
                    inputType: TextInputType.phone,
                    labelText: 'Phone',
                    prefixIcon: IconBroken.Call,
                    validat: (String? value) {
                      if (value!.isEmpty) {
                        return 'bio must be empty';
                      }
                      return null;
                    },
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
