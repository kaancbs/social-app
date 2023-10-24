import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_social_app/core/providers/storage_repository_provider.dart';
import 'package:random_social_app/core/utils.dart';
import 'package:random_social_app/features/auth/controller/auth_controller.dart';
import 'package:random_social_app/features/posts/repostiory/post_repostiory.dart';
import 'package:random_social_app/models/post_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  return PostController(
      postRepostiory: ref.watch(postRepositoryProvider),
      ref: ref,
      storageRepository: ref.watch(storageRepositoryProvider));
});
final userPostsProvider = StreamProvider((ref) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchUserPosts();
});

class PostController extends StateNotifier<bool> {
  final PostRepostiory _postRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  PostController(
      {required PostRepostiory postRepostiory,
      required Ref ref,
      required StorageRepository storageRepository})
      : _postRepository = postRepostiory,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void shareTextPost(
      {required BuildContext context, required String description}) async {
    state = true;

    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final Post post = Post(
        description: description,
        id: postId,
        uid: user.uid,
        type: 'textPost',
        createdAt: DateTime.now(),
        likes: [],
        dislikes: [],
        commentCount: 0);

    final res = await _postRepository.addPost(post);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Posted succesfully');
      Routemaster.of(context).pop();
    });
  }

  void shareImagePost(
      {required BuildContext context,
      required String description,
      required File? file}) async {
    state = true;

    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final imageRes = await _storageRepository.storeFile(
        path: 'posts/ ', id: postId, file: file);

    imageRes.fold((l) => showSnackBar(context, l.message), (r) async {
      String? describe;
      if (description != '') {
        describe = description;
      } else {
        describe = null;
      }
      final Post post = Post(
          description: describe,
          id: postId,
          uid: user.uid,
          type: 'imagePost',
          createdAt: DateTime.now(),
          likes: [],
          dislikes: [],
          commentCount: 0,
          link: r);
      final res = await _postRepository.addPost(post);
      state = false;
      res.fold((l) => showSnackBar(context, l.message), (r) {
        showSnackBar(context, 'Posted Sucessfuly');
        Routemaster.of(context).pop();
      });
    });
  }

  void deletePost(Post post, BuildContext context) async {
    final res = await _postRepository.deletePost(post);

    res.fold((l) => showSnackBar(context, l.message),
        (r) => showSnackBar(context, 'Post deleted succesfuly'));
  }

  void upVote(Post post) async {
    final uid = _ref.read(userProvider)!.uid;
    _postRepository.upVote(post, uid);
  }

  void downVote(Post post) async {
    final uid = _ref.read(userProvider)!.uid;
    _postRepository.downVote(post, uid);
  }

  Stream<List<Post>> fetchUserPosts() {
    return _postRepository.fetchPosts();
  }
}
