import 'package:chat_with_me/models/social_user_model/social_user_model.dart';
import 'package:chat_with_me/shared/components/components.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/cubits/layout_cubit/cubit.dart';
import '../../../shared/cubits/layout_cubit/states.dart';
import '../chat_details_screen/chat_details_screen.dart';

class UserChatsScreen extends StatelessWidget {
  const UserChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(  //update the UI when state change/ like hoks
        listener: (context, state) {},
        builder: (context, state) {
          return ConditionalBuilder(
              condition: SocialCubit.get(context).users.isNotEmpty ||
                  (state is SocialGetAllUsersSuccessState &&
                      SocialCubit.get(context).users.isEmpty),
              builder: (context) => SocialCubit.get(context).users.isEmpty
                  ? const Center(
                      child: Text('You don\'t have friends yet..💔'),
                    )
                  : ListView.separated(
                      itemBuilder: (context, index) => buildChatItem(
                          SocialCubit.get(context).users[index], context),
                      separatorBuilder: (context, index) => Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                20,), // Adjust the horizontal padding as needed
                        child: Divider(),
                      ),
                      itemCount: SocialCubit.get(context).users.length,
                    ),
              fallback: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ));
        });
  }

  buildChatItem(SocialUserModel userModel, context) => InkWell(
        onTap: () {
          navigateTo(
              context,
              ChatDetailsScreen(
                userModel: userModel,
              ));
        },
        child: Padding(
       padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 3.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(userModel.image!),
              ),
              const SizedBox(width: 15),
              Text(userModel.name!,
               style: TextStyle(fontSize: 16),),
            ],
          ),
        ),
      );
}
