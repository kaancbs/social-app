import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_social_app/core/utils.dart';
import 'package:random_social_app/features/auth/controller/auth_controller.dart';
import 'package:random_social_app/features/user_profile/controller/user_profile_controller.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? profileFile;
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // nicknameController =
    //     TextEditingController(text: ref.read(userProvider)!.nickname);
    // nameController = TextEditingController(text: ref.read(userProvider)!.name);
  }

  @override
  void dispose() {
    super.dispose();
    nicknameController.dispose();
    nameController.dispose();
  }

  void save() {
    String name = ref.read(userProvider)!.name;
    String nickName = ref.read(userProvider)!.nickname;
    if (nameController.text.trim() != '') {
      name = nameController.text.trim();
    }
    if (nicknameController.text.trim() != '') {
      nickName = nicknameController.text.trim();
    }

    ref.read(userProfileControllerProvider.notifier).editUser(
        name: name,
        nickName: nickName,
        profileFile: profileFile,
        context: context);
  }

  void selectProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Editing profile'),
        actions: [TextButton(onPressed: save, child: const Text('Save'))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Stack(
              children: [
                InkWell(
                    child: profileFile == null
                        ? CircleAvatar(
                            radius: 70,
                            backgroundImage: NetworkImage(user.profilePic))
                        : CircleAvatar(
                            radius: 70,
                            backgroundImage: FileImage(profileFile!),
                          )),
                Positioned(
                  right: -5,
                  bottom: -5,
                  child: IconButton(
                    onPressed: selectProfileImage,
                    icon: const Icon(
                      Icons.edit,
                      size: 25,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 5),
            TextField(
              controller: nicknameController,
              decoration: InputDecoration(
                helperText: 'Nickname',
                hintText: user.nickname,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.blue,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(18),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                helperText: 'Name',
                hintText: user.name,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.blue,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
