import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_practice2/Features/App/Splash%20Screen/splash_screen.dart';
import 'package:firebase_practice2/Features/User%20Auth/Pages/login_page.dart';
import 'package:firebase_practice2/Features/User%20Auth/Phone%20Auth/sign_in_phone.dart';
import 'package:firebase_practice2/Screen/home_screen.dart';
import 'package:firebase_practice2/Services/notification_services.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBf-lFGOPFe9Id6yUK9UBy24csx71J8xJk",
      appId: "1:338869737571:android:48ffd479b0026f950dc056",
      messagingSenderId: "338869737571",
      projectId: "new-firebase-edc0b",
      storageBucket: "gs://new-firebase-edc0b.appspot.com/"
    ),
  );

  await NotificationServices.initialize();

  // FirebaseFirestore _firestore = await FirebaseFirestore.instance;

  // Firebase firestore data fetch
  // DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection("user").doc("gMomKj2YLpatCE9HEdw3").get();
  //
  // log(snapshot.data().toString());

  // Firebase firestore data inside
  // Map<String, dynamic> newUserData = {
  //   "name" : "Ifran",
  //   "email" : "ifran@gmail.com",
  // };
  //
  // _firestore.collection("user").doc("Your-id-hear").update({
  //   "name" : "updateUser",
  //   "email" : "updateuseremail@gmail.com",
  // });
  // log("User updated");

  // Firebase firestore data delete
  // _firestore.collection("user").doc("Your-id-hear").delete();
  // log("User deleted");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(
        child: HomeScreen(), // (FirebaseAuth.instance.currentUser != null) ? HomeScreen() : SingInWithPhone(),
      ),
    );
  }
}
