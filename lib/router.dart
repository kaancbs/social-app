import 'package:flutter/material.dart';
import 'package:random_social_app/features/auth/screens/login_screen.dart';
import 'package:random_social_app/features/auth/screens/sign_in_screen.dart';
import 'package:random_social_app/features/home/screens/app_settings_screen.dart';
import 'package:random_social_app/features/home/screens/edit_profile.dart';
import 'package:random_social_app/features/home/screens/home_screen.dart';
import 'package:random_social_app/features/home/screens/profile_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => MaterialPage(child: LoginScreen()),
  '/signin': (_) => MaterialPage(child: SignInScreen()),
});
final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  '/app-settings': (_) => const MaterialPage(child: AppSettingsPage()),
  '/profile/:uid': (routeData) => MaterialPage(
          child: ProfilePage(
        uid: routeData.pathParameters['uid']!,
      )),
  '/profile/edit-profile': (routeData) =>
      const MaterialPage(child: EditProfileScreen()),
});
