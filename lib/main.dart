import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';
import 'package:taskmanager/screens/home.dart';
import 'package:taskmanager/screens/splash.dart';
import 'config/palette.dart';



Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(new TaskManagerApp());
}




class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LitAuthInit(
      authProviders: const AuthProviders(
        emailAndPassword: true,
        google: true,
        apple: true,
        twitter: true,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.muliTextTheme(),
          accentColor: Palette.darkOrange,
          appBarTheme: const AppBarTheme(
            brightness: Brightness.dark,
            color: Palette.darkBlue,
          ),
        ),

        home: const LitAuthState(
          authenticated: HomeScreen(),
          unauthenticated: SplashScreen(),
        ),
        //home: const SplashScreen(),
      ),
    );
  }
}