import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:random_social_app/core/failure.dart';
import 'package:random_social_app/core/firebase_providers.dart';
import 'package:random_social_app/core/typedefs.dart';
import 'package:random_social_app/models/user_model.dart';

final authRepostioryProvider = Provider((ref) => AuthRepository(
    firestore: ref.read(fireStoreProvider), auth: ref.read(authProvider)));

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  AuthRepository(
      {required FirebaseFirestore firestore, required FirebaseAuth auth})
      : _auth = auth,
        _firestore = firestore;
  CollectionReference get _users => _firestore.collection('users');

  Stream<User?> get authStateChange => _auth.authStateChanges();
  FutureEither<UserModel> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      UserModel userModel;
      if (userCredential.additionalUserInfo!.isNewUser) {
        List<String> parts = email.split('@');
        String name = parts[0];
        userModel = UserModel(
            name: name,
            nickname: name,
            uid: userCredential.user!.uid,
            profilePic: '',
            following: [],
            followers: []);
        await _users.doc(userModel.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<UserModel> logIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      UserModel userModel = await getUserData(userCredential.user!.uid).first;

      return right(userModel);
    } on FirebaseException catch (e) {
      print(e.message);
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  void logOut() async {
    await _auth.signOut();
  }
}
