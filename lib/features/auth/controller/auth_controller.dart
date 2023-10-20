import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_social_app/core/utils.dart';
import 'package:random_social_app/features/auth/repository/auth_repository.dart';
import 'package:random_social_app/models/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) {
  return null;
});
final authControllerProvider = StateNotifierProvider<AuthController, bool>(
    (ref) => AuthController(
        authRepository: ref.watch(authRepostioryProvider), ref: ref));

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);

  return authController.authStateChange;
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  void signIn(BuildContext context, String email, String password) async {
    state = true;
    final user = await _authRepository.signIn(email, password);
    state = false;

    user.fold((l) => showSnackBar(context, l.message), (_) {});
  }

  void logIn(BuildContext context, String email, String password) async {
    state = true;
    final user = await _authRepository.logIn(email, password);
    state = false;

    user.fold((l) => showSnackBar(context, l.message),
        (user) => _ref.read(userProvider.notifier).state = user);
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  void logOut() async {
    _authRepository.logOut();
  }
}
