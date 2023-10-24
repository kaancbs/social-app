import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:random_social_app/core/failure.dart';
import 'package:random_social_app/core/firebase_constants.dart';
import 'package:random_social_app/core/firebase_providers.dart';
import 'package:random_social_app/core/typedefs.dart';
import 'package:random_social_app/models/post_model.dart';

final postRepositoryProvider = Provider((ref) {
  return PostRepostiory(firestore: ref.watch(firestoreProvider));
});

class PostRepostiory {
  final FirebaseFirestore _firestore;

  PostRepostiory({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);

  FutureVoid addPost(Post post) async {
    try {
      return right(_posts.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid deletePost(Post post) async {
    try {
      return right(_posts.doc(post.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  void upVote(Post post, String uid) async {
    if (post.dislikes.contains(uid)) {
      _posts.doc(post.id).update({
        'dislikes': FieldValue.arrayRemove([uid])
      });
    }
    if (post.likes.contains(uid)) {
      _posts.doc(post.id).update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      _posts.doc(post.id).update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }

  void downVote(Post post, String uid) async {
    if (post.likes.contains(uid)) {
      _posts.doc(post.id).update({
        'likes': FieldValue.arrayRemove([uid])
      });
    }
    if (post.dislikes.contains(uid)) {
      _posts.doc(post.id).update({
        'dislikes': FieldValue.arrayRemove([uid])
      });
    } else {
      _posts.doc(post.id).update({
        'dislikes': FieldValue.arrayUnion([uid])
      });
    }
  }

  Stream<List<Post>> fetchPosts() {
    return _posts.orderBy('createdAt', descending: true).snapshots().map(
        (event) => event.docs
            .map((e) => Post.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }
}
