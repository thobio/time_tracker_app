import 'package:flutter/material.dart';
import 'package:time_tracker_app/services/auth.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key, required this.authbase});
  final AuthBase authbase;

  Future<void> _signInAnonymously() async {
    try {
      await authbase.signInAnonymosly();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(),
      backgroundColor: Colors.white.withOpacity(0.97),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text(
              "Sign In",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                  Colors.white,
                ),
                elevation: MaterialStatePropertyAll(
                  1.0,
                ),
                fixedSize: MaterialStatePropertyAll(
                  Size.fromWidth(60.0),
                ),
              ),
              onPressed: _signinWithGoogle,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset("images/google-logo.png"),
                  const Text(
                    "Sign in with Google",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15.0,
                    ),
                  ),
                  Opacity(
                      opacity: 0, child: Image.asset("images/google-logo.png")),
                ],
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            const Spacer(),
          ]),
    );
  }

  Future<void> _signinWithGoogle() async {
    try {
      await authbase.signInwithGoogle();
    } catch (e) {
      print(e.toString());
    }
  }
}
