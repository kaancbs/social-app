import 'package:flutter/material.dart';
import 'package:random_social_app/features/auth/screens/login_screen.dart';
import 'package:random_social_app/features/auth/screens/sign_in_screen.dart';
import 'package:random_social_app/features/home/screens/home_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => MaterialPage(child: LoginScreen()),
  '/signin': (_) => MaterialPage(child: SignInScreen()),
});
final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
});
