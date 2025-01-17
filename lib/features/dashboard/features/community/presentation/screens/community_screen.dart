import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/app/app_exporter.dart';
import 'package:meditouch/common/widgets/custom_loading_animation.dart';
import 'package:meditouch/common/widgets/image_view_remote.dart';
import 'package:meditouch/features/dashboard/features/community/data/repository/community_repository.dart';
import 'package:readmore/readmore.dart';
import '../../data/models/community_model.dart';
import '../../logics/community_bloc.dart';
import '../../logics/community_events.dart';
import '../../logics/community_state.dart';
import 'community_add_post_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final TextEditingController _postController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CommunityBloc>().add(FetchPosts());
  }

  @override
  Widget build(BuildContext context) {
    // get theme:
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.surfaceContainer,
      appBar: AppBar(

        backgroundColor: theme.surfaceContainer,
        title: const Text("Community"),elevation: 0,surfaceTintColor: theme.surfaceContainer,),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildPostInput(context, theme),
            const SizedBox(height: 20),
            Expanded(child: _buildPostList(context, theme)),
          ],
        ),
      ),
    );
  }

  Widget _buildPostInput(BuildContext context, ColorScheme theme) {
    return GestureDetector(
      onTap: () {
        // go to add post screen:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const CommunityAddPostScreen(),
        ));
      },
      child: Container(
        width: double.infinity,
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: theme.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, color: theme.onSurface.withOpacity(.5)),
            const SizedBox(width: 10),
            Text('Write something here...',
                style: TextStyle(color: theme.onSurface.withOpacity(.5))),
          ],
        ),
      ),
    );
  }

  Widget _buildPostList(BuildContext context, ColorScheme theme) {
    return FutureBuilder(
        future: HiveRepository().getUserInfo(),
        builder: (context, localUserSnapshot) {
          if (localUserSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CustomLoadingAnimation(size: 25, color: theme.primary));
          }

          if (localUserSnapshot.hasError || localUserSnapshot.data == null) {
            return Center(child: Text(localUserSnapshot.error.toString()));
          }

          final Map<String, dynamic> localUser = localUserSnapshot.data!;

          return BlocBuilder<CommunityBloc, CommunityState>(
            builder: (context, state) {
              if (state is CommunityLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CommunityLoaded) {
                final posts = state.posts;
                return ListView.builder(
                  itemCount: posts.length,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return StreamBuilder(
                      stream:
                          CommunityRepository().getUserDataByUid(post.postedBy),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Center(
                                child: CustomLoadingAnimation(
                                    size: 25, color: theme.primary)),
                          );
                        }

                        if (userSnapshot.hasError ||
                            userSnapshot.data == null) {
                          return Center(
                              child: Text(userSnapshot.error.toString()));
                        }

                        final UserAccountModel user = userSnapshot.data!;

                        return Container(
                          // padding: const EdgeInsets.all(10),
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: theme.primary.withOpacity(.1),
                                width: 1.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              user.imageUrl),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(user.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: theme.onSurface,
                                                fontWeight: FontWeight.bold)),
                                        Text(formatTimestamp(post.postTime),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: theme.onSurface
                                                    .withOpacity(.5),
                                                fontSize: 12)),
                                      ],
                                    )
                                  ],
                                ),
                              ),

                              // post text:
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: ReadMoreText(
                                  post.text,
                                  trimMode: TrimMode.Line,
                                  trimLines: 2,
                                  colorClickableText: theme.primary,
                                  trimCollapsedText: 'Show more',
                                  trimExpandedText: 'Show less',
                                  moreStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),

                              // post image if available:
                              if (post.image != null)
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: GestureDetector(
                                    onTap: () {
                                      // go to view image screen:
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => ImageViewer(
                                                  imageUrl: post.image!)));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: post.image!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 200,
                                        progressIndicatorBuilder:
                                            (context, url, progress) {
                                          return Center(
                                            child: CustomLoadingAnimation(
                                              size: 25,
                                              color: theme.primary,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),

                              // post actions:
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          print('id: ${localUser['id']}');
                                          context.read<CommunityBloc>().add(
                                              ToggleReact(
                                                  post.id, localUser['id']));
                                        },
                                        icon: Icon(
                                            post.reacts
                                                    .contains(localUser['id'])
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: post.reacts
                                                    .contains(localUser['id'])
                                                ? theme.primary
                                                : theme.onSurface
                                                    .withOpacity(.5))),
                                    // const SizedBox(width: 5),
                                    IconButton(
                                        onPressed: () {
                                          // go to comment screen:
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CommentScreen(
                                                        postId: post.id,
                                                        userId: localUser['id'],
                                                      )));
                                        },
                                        icon: Icon(Icons.comment,
                                            color: theme.onSurface
                                                .withOpacity(.5))),

                                    const SizedBox(width: 5),

                                    Expanded(
                                        child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text('${post.reacts.length} likes & ${post.comments.length} comments',
                                            style: TextStyle(
                                                color: theme.onSurface
                                                    .withOpacity(.5),
                                                fontSize: 12)),
                                        const SizedBox(width: 10),

                                      ],
                                    )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              } else if (state is CommunityError) {
                return Center(child: Text(state.error));
              }
              return const Center(child: Text("No posts available."));
            },
          );
        });
  }
}

// format timestamp to date-time string
// e.g. 2022-01-01 12:00 PM
String formatTimestamp(Timestamp timestamp) {
  final date = timestamp.toDate();
  final hour = date.hour > 12 ? date.hour - 12 : date.hour;
  final minute = date.minute.toString().padLeft(2, '0');
  final period = date.hour > 12 ? 'PM' : 'AM';
  return '$hour:$minute $period, ${date.year}-${date.month}-${date.day}';
}

class CommentScreen extends StatelessWidget {
  CommentScreen({super.key, required this.postId, required this.userId});

  final String postId;
  final String userId;

  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // get theme:
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comments"),
        elevation: 0,
        surfaceTintColor: theme.surfaceContainer,
        backgroundColor: theme.surfaceContainer,
      ),
      backgroundColor: theme.surfaceContainer,
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                        stream: CommunityRepository().getComments(postId),
                        builder: (context, commentsSnapshot) {
                          if (commentsSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: CustomLoadingAnimation(
                                    size: 25, color: theme.primary));
                          }

                          if (commentsSnapshot.hasError ||
                              commentsSnapshot.data == null) {
                            return Center(
                                child: Text(commentsSnapshot.error.toString()));
                          }

                          final List<CommentModel> comments =
                              commentsSnapshot.data!;

                          if (comments.isEmpty) {
                            return Center(
                                child: Text("No comments available."));
                          }

                          return ListView.builder(
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              return StreamBuilder<UserAccountModel?>(
                                  stream: CommunityRepository()
                                      .getUserDataByUid(
                                          comments[index].commenterId),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Center(
                                            child: CustomLoadingAnimation(
                                                size: 25,
                                                color: theme.primary)),
                                      );
                                    }

                                    if (snapshot.hasError ||
                                        snapshot.data == null) {
                                      return Center(
                                          child:
                                              Text(snapshot.error.toString()));
                                    }

                                    final UserAccountModel user =
                                        snapshot.data!;

                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 15),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundImage: user.imageUrl !=
                                                        null &&
                                                    user.imageUrl.isNotEmpty
                                                ? CachedNetworkImageProvider(
                                                    user.imageUrl)
                                                : null,
                                            child: user.imageUrl == null ||
                                                    user.imageUrl.isEmpty
                                                ? Icon(Icons.person,
                                                    color: theme.onSurface)
                                                : null, // Fallback icon if no image
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: theme.primaryContainer,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    user.name,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: theme.onSurface,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                      height:
                                                          5), // Add spacing between name and comment
                                                  ReadMoreText(
                                                    comments[index].commentText,
                                                    style: TextStyle(
                                                        color: theme.onSurface
                                                            .withOpacity(.7),
                                                      fontSize: 13,
                                                    ),
                                                    trimMode: TrimMode.Line,
                                                    trimLines: 2,
                                                    colorClickableText:
                                                        Colors.pink,
                                                    trimCollapsedText:
                                                        ' Show more',
                                                    trimExpandedText:
                                                        ' Show less',
                                                    moreStyle: TextStyle(
                                                        fontSize: 13,
                                                        color: theme.primary,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                          );
                        }),
                  ),

                  // add comment input:
                  Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: theme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            decoration: InputDecoration(
                              hintText: 'Write a comment...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // add comment:
                            context.read<CommunityBloc>().add(AddComment(
                                postId,
                                CommentModel(
                                  commentText: _commentController.text,
                                  commenterId: userId,
                                )));
                            _commentController.clear();
                          },
                          icon: Icon(Icons.send, color: theme.primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ))),
    );
  }
}
