import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_social_app/features/auth/controller/auth_controller.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void navigateToAppSettings(BuildContext context) {
    Navigator.pop(context);
    Routemaster.of(context).push('/app-settings');
  }

  void navigateToProfilePage(BuildContext context, String uid) {
    Navigator.pop(context);
    Routemaster.of(context).push('/profile/$uid');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Drawer(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5)
                      .copyWith(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(user.profilePic,),
                        radius: 50,
                      ),
                      Column(children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          user.nickname,
                          style: const TextStyle(
                              color: Colors.white60, fontSize: 16),
                        )
                      ]),
                      const SizedBox(),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(
                  indent: 10,
                  endIndent: 10,
                  thickness: 2,
                ),
                ListTile(
                  onTap: () => navigateToProfilePage(context, user.uid),
                  leading: const Icon(
                    Icons.person,
                    size: 38,
                  ),
                  title: const Text('My Profile'),
                ),
                ListTile(
                  onTap: () => navigateToAppSettings(context),
                  leading: const Icon(
                    Icons.settings,
                    size: 38,
                  ),
                  title: const Text('App Settings'),
                ),
              ],
            ),
            Column(
              children: [
                ListTile(
                  onTap: () {
                    ref.read(authControllerProvider.notifier).logOut();
                  },
                  leading: const Icon(
                    Icons.logout,
                    size: 38,
                  ),
                  title: const Text('Log Out'),
                ),
                const Divider(
                  color: Colors.white54,
                  thickness: 1,
                  endIndent: 30,
                  indent: 30,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 10),
                  child: Text(
                    'Random Social App',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.white70),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
