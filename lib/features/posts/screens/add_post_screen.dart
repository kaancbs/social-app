import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_social_app/core/utils.dart';
import 'package:random_social_app/features/auth/controller/auth_controller.dart';
import 'package:random_social_app/features/posts/controller/post_controller.dart';

class AddPostScreen extends ConsumerStatefulWidget {
  const AddPostScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends ConsumerState<AddPostScreen> {
  final TextEditingController descriptionController = TextEditingController();
  File? postPicture;

  void shareTextPost(BuildContext context, String description) {
    ref
        .read(postControllerProvider.notifier)
        .shareTextPost(context: context, description: description);
  }

  void shareImagePost(BuildContext context, String description, File file) {
    ref
        .read(postControllerProvider.notifier)
        .shareImagePost(context: context, description: description, file: file);
  }

  void selectProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        postPicture = File(res.files.first.path!);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                if (descriptionController.text.trim() != '') {
                  String description = descriptionController.text.trim();
                  if (postPicture != null) {
                    shareImagePost(context, description, postPicture!);
                  } else {
                    shareTextPost(context, description);
                  }
                }
                if (descriptionController.text.trim() == '' &&
                    postPicture != null) {
                  shareImagePost(
                      context, descriptionController.text.trim(), postPicture!);
                }
              },
              child: const Text(
                'Share',
                style: TextStyle(fontSize: 16),
              ))
        ],
        title: const Text('Share Post'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              SizedBox(
                height: 265,
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(user.profilePic),
                        ),
                        const SizedBox(width: 20),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            user.nickname,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    TextField(
                      textInputAction: TextInputAction.none,
                      controller: descriptionController,
                      maxLines: 8,
                      decoration: const InputDecoration(
                        hintText: 'Enter Something',
                        hintStyle: TextStyle(fontWeight: FontWeight.bold),
                        filled: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(18),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 2,
              ),
              postPicture == null
                  ? const SizedBox()
                  : SizedBox(
                      height: 300,
                      width: 300,
                      child: Image(image: FileImage(postPicture!)),
                    ),
              ListTile(
                onTap: selectProfileImage,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.white, width: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                leading: const Icon(Icons.image),
                title: const Text('Add Photo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
