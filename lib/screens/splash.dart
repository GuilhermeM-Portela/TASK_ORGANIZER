import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';
import 'package:taskmanager/home/ui/page_workspace.dart';

import 'auth/auth.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  static MaterialPageRoute get route => MaterialPageRoute(
        builder: (context) => const SplashScreen(),
      );

  @override
  Widget build(BuildContext context) {
    // final user = context.getSignedInUser();
    final litUser = context.watchSignedInUser();
    litUser.map(

          (value) {
        // _navigateToHomeScreen(context);
        _navigateToWorkspacePage(context);
      },
      empty: (_) {
        _navigateToAuthScreen(context);
      },

      initializing: (_) {
      },
    );

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _navigateToAuthScreen(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
          (_) => Navigator.of(context).pushReplacement(AuthScreen.route),
    );
  }

  void _navigateToWorkspacePage(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
          (_) => Navigator.of(context).pushReplacement(WorkspacePage.route),
    );
  }
}
