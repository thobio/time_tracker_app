import 'package:flutter/material.dart';
import 'package:time_tracker_app/App/home_page.dart';
import 'package:time_tracker_app/App/sign_in/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_tracker_app/services/auth.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key, required this.authBase});
  final AuthBase authBase;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return SignInPage(
              authbase: authBase,
            );
          }
          return HomePage(
            authbase: authBase,
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      stream: authBase.authStateChanges(),
    );
  }
}
