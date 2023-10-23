import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_practice2/Features/User%20Auth/Pages/sign_up_page.dart';
import 'package:firebase_practice2/Features/User%20Auth/Phone%20Auth/sign_in_phone.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _ageController = TextEditingController();

  // Profile pic
  File? profilePic;
  // save data
  void _saveData() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String ageString = _ageController.text.trim();
    int age = int.parse(ageString);

    _nameController.clear();
    _emailController.clear();
    _ageController.clear();

    if (name != "" && email != "" && profilePic != null) {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child("Profile Picture")
          .child("Profile")
          .putFile(profilePic!);

      StreamSubscription streamSubscription =
          uploadTask.snapshotEvents.listen((event) {
        double percentage = event.bytesTransferred / event.totalBytes * 100;
        log(percentage.toString());
      });

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      streamSubscription.cancel();

      Map<String, dynamic> userdata = {
        "name": name,
        "email": email,
        "age": age,
        "profilePic": downloadUrl,
      };
      await FirebaseFirestore.instance.collection("user").add(userdata);
      log("User Created!!");
    } else {
      log("Please fill all the fields");
    }
    // null profile pic
    setState(() {
      profilePic = null;
    });
  }

  void getInitialMessage() async{
    RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();
    if(message != null){
      if(message.data["page"] == "email"){
        Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage(),));
      }
      else if(message.data["page"] == "phone"){
        Navigator.push(context, MaterialPageRoute(builder: (context) => SignInWithPhone(),));
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Invilade page!!"),
            duration: Duration(seconds: 10),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getInitialMessage();

    FirebaseMessaging.onMessage.listen((message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message.notification!.body.toString()),
          duration: Duration(seconds: 10),
          backgroundColor: Colors.green,
        ),
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("App was opened by a notification"),
          duration: Duration(seconds: 10),
          backgroundColor: Colors.green,
        ),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home Screen",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            CupertinoButton(
              onPressed: () async {
                XFile? selectedImage =
                    await ImagePicker().pickImage(source: ImageSource.gallery);

                if (selectedImage != null) {
                  File convertedFile = File(selectedImage.path);
                  setState(() {
                    profilePic = convertedFile;
                  });
                  log("Image selected!1");
                } else {
                  log("Image not selected!!");
                }
              },
              child: CircleAvatar(
                backgroundImage:
                    (profilePic != null) ? FileImage(profilePic!) : null,
                radius: 50,
                backgroundColor: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: "Name",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _ageController,
                decoration: const InputDecoration(
                  hintText: "Age",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                _saveData();
              },
              child: const Text(
                "Save",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection("user").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> userData =
                              snapshot.data!.docs[index].data();

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(userData["profilePic"]),
                            ),
                            title: Text(
                                userData["name"] + " (${userData["age"]})"),
                            subtitle: Text(userData["email"]),
                            trailing: IconButton(
                              onPressed: () {
                                // delete data
                                // FirebaseFirestore.instance.collection("user").doc().delete();
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Text("No Data");
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
