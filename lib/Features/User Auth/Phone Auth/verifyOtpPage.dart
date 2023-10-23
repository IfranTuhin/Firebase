import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice2/Features/User%20Auth/Widght/form_contaner_widget.dart';
import 'package:firebase_practice2/Screen/home_screen.dart';
import 'package:flutter/material.dart';

class VerifyOtpPage extends StatefulWidget {
  final String varificationId;
  const VerifyOtpPage({Key? key, required this.varificationId})
      : super(key: key);

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  TextEditingController otpController = TextEditingController();

  void _verifyOtp() async {
    String otp = otpController.text.trim();

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.varificationId,
      smsCode: otp,
    );
    try{
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      if(userCredential.user != null){
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
      }
    } on FirebaseAuthException catch(ex){
      log(ex.code.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Otp"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FormContainerWidget(
                controller: otpController,
                hintText: "6-Digit OTP",
              ),
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: _verifyOtp,
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text(
                      "Verify",
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
