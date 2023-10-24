import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_social_app/core/common/error_text.dart';
import 'package:random_social_app/core/common/loader.dart';
import 'package:random_social_app/core/constants.dart';
import 'package:random_social_app/features/auth/controller/auth_controller.dart';
import 'package:random_social_app/features/posts/controller/post_controller.dart';
import 'package:random_social_app/features/user_profile/controller/user_profile_controller.dart';
import 'package:random_social_app/models/post_model.dart';
import 'package:random_social_app/theme/palette.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  void deletePost(WidgetRef ref, BuildContext context) async {
    ref.read(postControllerProvider.notifier).deletePost(post, context);
  }

  void upvotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).upVote(post);
  }

  void downVotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).downVote(post);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'imagePost';
    final currentUser = ref.watch(userProvider)!;

    final currentTheme = ref.watch(themeNotifierProvider);
    return Column(children: [
      Container(
        decoration: BoxDecoration(
          color: currentTheme.drawerTheme.backgroundColor,
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 16,
                    ).copyWith(right: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ref.watch(getUserByUidProvider(post.uid)).when(
                            data: (user) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () => (context),
                                        child: CircleAvatar(
                                          radius: 16,
                                          backgroundImage:
                                              NetworkImage(user.profilePic),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              user.nickname,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (post.uid == currentUser.uid)
                                    IconButton(
                                      onPressed: () => deletePost(ref, context),
                                      icon: const Icon(Icons.delete),
                                      color: Palette.redColor,
                                    )
                                ],
                              );
                            },
                            error: (e, stackTrace) =>
                                ErrorText(error: e.toString()),
                            loading: () => const Loader()),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: post.description != null
                              ? Text(
                                  '   ${post.description!}',
                                  style: const TextStyle(
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              : const SizedBox(),
                        ),
                        if (isTypeImage)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Image.network(
                              post.link!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  onPressed: () => upvotePost(ref),
                                  icon: Icon(Constants.up,
                                      size: 30,
                                      color:
                                          post.likes.contains(currentUser.uid)
                                              ? Palette.redColor
                                              : null),
                                ),
                                Text(
                                  '${post.likes.length - post.dislikes.length == 0 ? '0' : post.likes.length - post.dislikes.length}',
                                  style: const TextStyle(fontSize: 17),
                                ),
                                IconButton(
                                  onPressed: () => downVotePost(ref),
                                  icon: Icon(Constants.down,
                                      size: 30,
                                      color: post.dislikes
                                              .contains(currentUser.uid)
                                          ? Palette.blueColor
                                          : null),
                                ),
                              ],
                            ),
                            // Row(
                            //   children: [
                            //     IconButton(
                            //       onPressed: () {},
                            //       icon: const Icon(Icons.comment),
                            //     ),
                            //     Text(
                            //       '${post.commentCount == 0 ? 'Comment' : post.commentCount}',
                            //       style: const TextStyle(fontSize: 17),
                            //     ),
                            //   ],
                            // ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ]);
  }
}
