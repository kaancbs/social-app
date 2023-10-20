import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_social_app/core/common/loader.dart';
import 'package:random_social_app/core/utils.dart';
import 'package:random_social_app/features/auth/controller/auth_controller.dart';
import 'package:routemaster/routemaster.dart';

class SignInScreen extends ConsumerWidget {
  SignInScreen({super.key});
  final mailController = TextEditingController();
  final passwordControllerfirst = TextEditingController();
  final passwordControllersecond = TextEditingController();
  void navigateToLoginScreen(BuildContext context) {
    passwordControllerfirst.clear();
    passwordControllersecond.clear();
    mailController.clear();
    Routemaster.of(context).replace('/');
  }

  void signIn(
      BuildContext context, WidgetRef ref, String email, String password) {
    ref.read(authControllerProvider.notifier).signIn(context, email, password);
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
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'SIGN IN',
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
                      controller: passwordControllerfirst,
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
                    TextField(
                      controller: passwordControllersecond,
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
                        onPressed: () {
                          try {
                            if (passwordControllerfirst.text.trim() ==
                                passwordControllersecond.text.trim()) {
                              signIn(context, ref, mailController.text.trim(),
                                  passwordControllerfirst.text.trim());

                              passwordControllerfirst.clear();
                              passwordControllersecond.clear();
                              mailController.clear();

                              navigateToLoginScreen(context);
                            } else if (passwordControllerfirst.text.trim() !=
                                passwordControllersecond.text.trim()) {
                              throw 'Girdiginiz sifreler birbiriyle uyusmuyor';
                            } else {
                              throw 'Bilinmeyen bir hata olustu';
                            }
                          } catch (e) {
                            showSnackBar(context, e.toString());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size.fromWidth(100),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: const Text('Sign In'),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text("Already you have an account?"),
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () {
                            navigateToLoginScreen(context);
                          },
                          child: const Text(
                            'Log in!',
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
