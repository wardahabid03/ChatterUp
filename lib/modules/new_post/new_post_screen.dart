import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/cubits/layout_cubit/cubit.dart';
import '../../shared/cubits/layout_cubit/states.dart';
import '../../shared/style/icon_broken.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({Key? key}) : super(key: key);

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  TextEditingController textController = TextEditingController();
  TextEditingController tagController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is SocialCreatePostSuccessState) {
          textController.clear();
          tagController.clear();
          SocialCubit.get(context).postImage = null;
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel;
        var cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Create Post',
            actions: [
              defaultTextButton(
                onPress: () {
                  if (textController.text.isNotEmpty) {
                    if (cubit.postImage == null) {
                      cubit.createNewPost(
                        dateTime: DateTime.now().toString(),
                        text: textController.text,
                        tags: tagController.text.split(' '),
                      );
                    } else {
                      cubit.createNewPostWithImage(
                        dateTime: DateTime.now().toString(),
                        text: textController.text,
                        tags: tagController.text.split(' '),
                      );
                    }
                  } else {
                    showToast(
                      text: 'Type anything...',
                      state: ToastStates.warning,
                    );
                  }
                },
                text: 'Post',
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if (state is SocialCreatePostLoadingState)
                  const LinearProgressIndicator(),
                const SizedBox(height: 10),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        '${userModel?.image}',
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        '${userModel?.name}',
                        style: const TextStyle(height: 1.4),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: textController,
                    autocorrect: true,
                    decoration: const InputDecoration(
                      hintText: 'What\'s on your mind...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: tagController,
                  autocorrect: true,
                  decoration: const InputDecoration(
                    hintText: 'Add tags...',
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 20),
                if (cubit.postImage != null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          image: DecorationImage(
                            image: FileImage(cubit.postImage!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          cubit.removeImageFromPost();
                        },
                        icon: const CircleAvatar(
                          radius: 15,
                          backgroundColor: defaultColor,
                          foregroundColor: Colors.white,
                          child: Icon(
                            Icons.close,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          cubit.getPostImage();
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(IconBroken.Image),
                            SizedBox(width: 5),
                            Text('Add Photo'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
