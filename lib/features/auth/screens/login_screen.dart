import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_social_app/core/common/loader.dart';
import 'package:random_social_app/features/auth/controller/auth_controller.dart';
import 'package:routemaster/routemaster.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  void navigateToSignInScreen(BuildContext context) {
    mailController.clear();
    passwordController.clear();
    Routemaster.of(context).replace('/signin');
  }

  void logIn(
      String email, String password, WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider.notifier).logIn(context, email, password);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Random Social App'),
      ),
      body: isLoading
          ? const Loader()
          : Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'LOG IN',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: mailController,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Enter Mail here',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(18),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Enter Password here',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(18),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () => logIn(mailController.text.trim(),
                            passwordController.text.trim(), ref, context),
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size.fromWidth(100),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: const Text('Log In'),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text("Don't you have an account?"),
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () {
                            navigateToSignInScreen(context);
                          },
                          child: const Text(
                            'Sign in!',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
