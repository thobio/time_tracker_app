import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/App/sign_in/sign_in_bloc.dart';
import 'package:time_tracker_app/services/auth.dart';

import '../common_widgets/show_exception_alert_dialog.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  static Widget create(BuildContext context) {
    return Provider(
      create: (_) => SignInBloc(),
      child: const SignInPage(),
    );
  }

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInAnonymosly();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SignInBloc>(context, listen: false);
    return Scaffold(
      body: StreamBuilder<bool>(
          stream: bloc.isLoadingStream,
          initialData: false,
          builder: (context, snapshot) {
            return _buildContent(context, snapshot.data!);
          }),
      backgroundColor: Colors.white.withOpacity(0.97),
    );
  }

  Widget _buildContent(BuildContext context, bool isLoading) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            SizedBox(
              height: 50.0,
              child: _buildHeader(isLoading),
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
              onPressed: isLoading ? null : () => _signinWithGoogle(context),
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

  Widget _buildHeader(bool isLoading) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return const Text(
      "Sign In",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Future<void> _signinWithGoogle(BuildContext context) async {
    final bloc = Provider.of<SignInBloc>(context, listen: false);
    try {
      bloc.setIsLoading(true);
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInwithGoogle();
    } on Exception catch (e) {
      showExceptionAlertDialog(context, title: "Error", exception: e);
    } finally {
      bloc.setIsLoading(false);
    }
  }
}
