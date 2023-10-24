import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_social_app/core/providers/storage_repository_provider.dart';
import 'package:random_social_app/core/utils.dart';
import 'package:random_social_app/features/auth/controller/auth_controller.dart';
import 'package:random_social_app/features/user_profile/repository/user_profile_repository.dart';
import 'package:random_social_app/models/user_model.dart';
import 'package:routemaster/routemaster.dart';

final getUserByUidProvider = StreamProvider.family((ref, String uid) {
  return ref.watch(userProfileControllerProvider.notifier).getUserByUid(uid);
});
final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return UserProfileController(
      userProfileRepository: userProfileRepository,
      ref: ref,
      storageRepository: storageRepository);
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  UserProfileController(
      {required StorageRepository storageRepository,
      required UserProfileRepository userProfileRepository,
      required Ref ref})
      : _userProfileRepository = userProfileRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void editUser({
    required String? name,
    required String? nickName,
    required File? profileFile,
    required BuildContext context,
  }) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;
    if (profileFile != null) {
      final res = await _storageRepository.storeFile(
          path: 'users/profile', id: user.uid, file: profileFile);
      res.fold((l) => showSnackBar(context, l.message),
          (r) => user = user.copyWith(profilePic: r));
    }
    if (name != null) {
      user = user.copyWith(name: name);
    }
    if (nickName != null) {
      user = user.copyWith(nickname: nickName);
    }

    final res = await _userProfileRepository.editProfile(user);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      _ref.read(userProvider.notifier).update((state) => user);
      Routemaster.of(context).pop();
    });
  }

  Stream<UserModel> getUserByUid(String uid) {
    return _userProfileRepository.getUserByUid(uid);
  }
}
