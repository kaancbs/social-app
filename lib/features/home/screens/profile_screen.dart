import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_social_app/features/auth/controller/auth_controller.dart';
import 'package:routemaster/routemaster.dart';

class ProfilePage extends ConsumerWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});
  void navigateToEditProfile(BuildContext context) {
    Routemaster.of(context).push('/profile/edit-profile');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5).copyWith(top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                user.profilePic == ''
                    ? Container(
                        height: 100,
                        width: 100,
                        color: Colors.red,
                      )
                    : CircleAvatar(
                        backgroundImage: NetworkImage(
                          user.profilePic,
                        ),
                        radius: 50,
                      ),
                Expanded(
                  child: Column(children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      user.nickname,
                      style:
                          const TextStyle(color: Colors.white60, fontSize: 16),
                    ),
                  ]),
                ),
                IconButton(
                    onPressed: () => navigateToEditProfile(context),
                    icon: const Icon(
                      Icons.settings,
                      size: 35,
                    ))
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Divider(
            indent: 10,
            endIndent: 10,
            thickness: 2,
          ),
          const Text('My posts will shows up here')
        ],
      ),
    );
  }
}
