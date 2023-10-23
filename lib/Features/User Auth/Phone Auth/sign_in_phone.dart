import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice2/Features/User%20Auth/Phone%20Auth/verifyOtpPage.dart';
import 'package:firebase_practice2/Features/User%20Auth/Widght/form_contaner_widget.dart';
import 'package:flutter/material.dart';

class SignInWithPhone extends StatefulWidget {
  const SignInWithPhone({Key? key}) : super(key: key);

  @override
  State<SignInWithPhone> createState() => _SignInWithPhoneState();
}

class _SignInWithPhoneState extends State<SignInWithPhone> {
  //
  TextEditingController _phoneController = TextEditingController();

  // Send otp
  void _sendOTP() async {
    String phone = "+88" + _phoneController.text.trim();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      codeSent: (verificationId, forceResendingToken) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyOtpPage(varificationId: verificationId,),));
      },
      verificationCompleted: (phoneAuthCredential) {},
      verificationFailed: (error) {
        log(error.code.toString());
      },
      codeAutoRetrievalTimeout: (verificationId) {},
      timeout: Duration(seconds: 30),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign in with phone"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FormContainerWidget(
                controller: _phoneController,
                hintText: "Phone",
              ),
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: _sendOTP,
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text(
                      "Sing In",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
