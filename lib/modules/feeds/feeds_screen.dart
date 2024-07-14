import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

import '../../models/post_model/post_model.dart';
import '../../models/comment_model/comment_model.dart';
import '../../shared/components/constants.dart';
import '../../shared/cubits/layout_cubit/cubit.dart';
import '../../shared/cubits/layout_cubit/states.dart';
import '../../shared/style/icon_broken.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  _FeedsScreenState createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  late TextEditingController _searchController;
  late String _searchText;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchText = '';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SocialCubit.get(context);

        return Scaffold(
          
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            _searchText = _searchController.text;
                          });
                        },
                      ),
                      hintStyle: TextStyle(fontSize: 12.0),
                    ),
                    style: TextStyle(fontSize: 12.0),
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: (_searchText.isEmpty)
                    ? _buildFeedList(cubit)
                    : _buildSearchedFeedList(cubit),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeedList(SocialCubit cubit) {
    return (cubit.posts.isNotEmpty && cubit.userModel != null)
        ? SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) =>
                      buildPostItem(context, cubit.posts[index], index, cubit),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemCount: cubit.posts.length,
                ),
                const SizedBox(height: 10),
              ],
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }

  Widget _buildSearchedFeedList(SocialCubit cubit) {
    List<PostModel> searchedPosts = cubit.posts
        .where((post) =>
            post.tags?.contains(_searchText.toLowerCase()) ?? false)
        .toList();

    return (searchedPosts.isNotEmpty && cubit.userModel != null)
        ? SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => buildPostItem(
                      context, searchedPosts[index], index, cubit),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemCount: searchedPosts.length,
                ),
                const SizedBox(height: 10),
              ],
            ),
          )
        : const Center(child: Text('No posts found with this tag'));
  }

  Widget buildPostItem(
    BuildContext context,
    PostModel model,
    int index,
    SocialCubit cubit,
  ) {
    DateTime parsedDateTime = DateTime.parse(model.dateTime!);
    String formattedDateTime =
        DateFormat('yyyy-MM-dd HH:mm').format(parsedDateTime);

    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage('${model.image}'),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${model.name}',
                            style: const TextStyle(height: 1.4),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.check_circle,
                            size: 16,
                            color: defaultColor,
                          )
                        ],
                      ),
                      Text(
                        formattedDateTime,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(height: 1.4, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_horiz,
                    size: 16,
                  ),
                )
              ],
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[300],
              margin: const EdgeInsets.symmetric(vertical: 10),
            ),
            if (model.postImage != '')
              Container(
                width: double.infinity,
                height: 300,
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: NetworkImage('${model.postImage}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(5.0),
            ),
            Text(
              '${model.text}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: Wrap(
                children: model.tags?.map((tag) {
                  return Container(
                    height: 20,
                    margin: const EdgeInsetsDirectional.only(end: 4),
                    child: MaterialButton(
                      onPressed: () {},
                      minWidth: 1,
                      height: 25,
                      padding: EdgeInsets.zero,
                      child: Text(
                        '#$tag',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: defaultColor),
                      ),
                    ),
                  );
                }).toList() ??
                    [],
              ),
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[300],
              margin: const EdgeInsetsDirectional.only(bottom: 5),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: () {
                        buildCommentBottomSheet(
                            context, model, cubit, cubit.postIdList[index]);
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundImage:
                                NetworkImage('${cubit.userModel!.image}'),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            'write your comment ...',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(height: 1.4, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 42),
                    Expanded(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                        end: 8.0,
                        bottom: 3,
                        top: 3,
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${SocialCubit.get(context).likes[index]}',
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Colors.grey,
                                    ),
                          ),
                          // const SizedBox(width: 3),
                          IconButton(
                            onPressed: () {
                              cubit.likePost(cubit.postIdList[index], index);
                            },
                            icon: Icon(
                              cubit.isLiked(cubit.postIdList[index])
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 18,
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void buildCommentBottomSheet(
    BuildContext context,
    PostModel post,
    SocialCubit cubit,
    String postId,
  ) {
    TextEditingController commentController = TextEditingController();
    cubit.getCommentsForPost(postId);
    print("Post id: $postId");

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Scrollbar(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: post.comments?.length ?? 0,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              post.comments![index].commenterName ?? 'Unknown',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              post.comments![index].commentText ??
                                  'No comment text available',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: commentController,
                        decoration: InputDecoration(
                          hintText: 'Type your comment here...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                        ),
                        minLines: 1,
                        maxLines: 5,
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (commentController.text.isNotEmpty) {
                          CommentModel newComment = CommentModel(
                            commenterId: cubit.userModel?.uId,
                            commenterName: cubit.userModel?.name,
                            commentText: commentController.text,
                            commentDateTime: DateTime.now().toString(),
                          );
                          cubit.addCommentToPost(
                              postId, newComment);
                          commentController.clear();
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
