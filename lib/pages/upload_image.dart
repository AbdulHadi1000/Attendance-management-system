// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers

import 'dart:typed_data';
import 'dart:convert';
import 'package:attdendance_management_system/colors/colors.dart';
import 'package:attdendance_management_system/widgets/bold_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  Uint8List? _image;
  final FirebaseAuth _auth = FirebaseAuth.instance; // Initialize FirebaseAuth

  Future<void> uploadPhoto(Uint8List imageBytes) async {
    User? user = _auth.currentUser;

    if (user != null) {
      String email = user.email!; // Use the user's email
      try {
        await FirebaseFirestore.instance
            .collection("Userlist")
            .doc(email)
            .update({
          'photo': base64Encode(imageBytes),
        });
        print("Photo uploaded successfully!");
        print(email);
      } catch (error) {
        print("Error uploading photo: $error");
      }
    } else {
      print("No user is logged in.");
    }
  }

  Future<Uint8List?> imagePicker(ImageSource source) async {
    ImagePicker _imagepicker = ImagePicker();
    XFile? _file = await _imagepicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    } else {
      print("No file selected");
      return null;
    }
  }

  void selectImage() async {
    Uint8List? img = await imagePicker(ImageSource.gallery);
    if (img != null) {
      setState(() {
        _image = img;
      });
    }
  }

  void onUploadPhoto() async {
    User? user = _auth.currentUser;
    if (_image != null && user != null) {
      String email = user.email!;
      await uploadPhoto(_image!);
    } else {
      print("No image selected or user is not logged in.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white,
        ),
        backgroundColor: appBarColor,
        title: Boldtext(
          text: "Change Picture",
          size: 25,
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage:
                            MemoryImage(_image!), // Display picked image
                      )
                    : const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                          "https://t3.ftcdn.net/jpg/05/79/55/26/240_F_579552668_sZD51Sjmi89GhGqyF27pZcrqyi7cEYBH.jpg",
                        ),
                      ),
                Positioned(
                  left: 80,
                  bottom: -10,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(Icons.add_a_photo),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onUploadPhoto, // Trigger upload when pressed
              child: const Text("Upload Photo"),
            ),
          ],
        ),
      ),
    );
  }
}
