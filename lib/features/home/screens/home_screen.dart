import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:random_social_app/features/home/drawers/profile_drawer.dart';
import 'package:random_social_app/features/posts/screens/feed_screen.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void navigateToAddPostScreen(BuildContext context) {
    Routemaster.of(context).push('/share-post');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: const FeedScreen(),
      drawer: const ProfileDrawer(),
      appBar: AppBar(
        title: const Text('Random Social App'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.shade600,
        onPressed: () {
          navigateToAddPostScreen(context);
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: IconButton(
                icon: const Icon(
                  Icons.home,
                  size: 34,
                ),
                onPressed: () {},
              ),
            ),
            const Expanded(child: SizedBox()),
            const Expanded(
              child: SizedBox(),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }
}
