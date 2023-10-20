
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:random_social_app/features/home/drawers/profile_drawer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body:const Center(
        child: Text('Posts will shows up here'),
      ),
      drawer: const ProfileDrawer(),
      appBar: AppBar(
        title: const Text('Random Social App'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.shade600,
        onPressed: () {
          //Share a new post
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
