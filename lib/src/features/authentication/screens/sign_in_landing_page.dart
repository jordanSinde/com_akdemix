import 'package:com_akdemix/src/common_widgets/custtom_button.dart';
import 'package:com_akdemix/src/features/authentication/route/app_router.dart';
import 'package:flutter/material.dart';

class SignInLandingPage extends StatelessWidget {
  const SignInLandingPage({super.key});

  Future<void> _openSignup(BuildContext context) async {
    final navigator = Navigator.of(context);
    await navigator.pushNamed(
      AppRoutes.signInPhonePage,
      arguments: () => navigator.pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Firebase Phone Auth with Riverpod",
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Spacer(),
            const Center(child: FlutterLogo(size: 120)),
            const SizedBox(height: 30),
            Text(
              "Welcome to this demo app using Firebase Phone Authentication and Riverpod for its State Management",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/firebase.png",
                    width: 150,
                  ),
                  Image.asset(
                    "assets/riverpod.png",
                    width: 150,
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: "Sign in with phone number",
                onPressed: () => _openSignup(context),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
