import 'dart:convert';
import 'dart:typed_data';

import 'package:attdendance_management_system/pages/loginpage.dart';
import 'package:attdendance_management_system/pages/recordpage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:attdendance_management_system/pages/attendancePage.dart';
import 'package:attdendance_management_system/pages/upload_image.dart';
import 'package:attdendance_management_system/widgets/bold_text.dart';
import 'package:attdendance_management_system/colors/colors.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  String? username;
  String? profileImageBase64;
  Uint8List? profileImageBytes;

  @override
  void initState() {
    super.initState();
    fetchuserdata();
    // Fetch user data when the screen loads
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> fetchuserdata() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection("Userlist")
            .doc(currentUser.email)
            .get();

        if (userDoc.exists) {
          setState(() {
            username = userDoc['username'];
            profileImageBase64 = userDoc['photo'];

            // Decode the Base64 string only if it exists
            if (profileImageBase64 != null && profileImageBase64!.isNotEmpty) {
              profileImageBytes = base64Decode(profileImageBase64!);
            }
          });
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Loginpage()));
    print("User logged out");
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: _logout,
        child: Container(
          decoration: BoxDecoration(
              color: appBarColor, borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Boldtext(
              text: "Log Out",
              color: Colors.white,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        primary: false,
        backgroundColor: appBarColor,
        centerTitle: true,
        title: Boldtext(
          text: "Dashboard",
          color: Colors.white,
          size: 30,
        ),
      ),
      body: ListView(
        children: [
          // Top Welcome Section
          Container(
            decoration: BoxDecoration(
              color: appBarColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            height: screenSize.height * 0.2,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.05),
              child: ListTile(
                title: username != null
                    ? Center(
                        child: Container(
                          child: Column(
                            children: [
                              const Text(
                                'Welcome Back',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              Text(
                                '$username',
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const Center(
                        child:
                            CircularProgressIndicator(), // Display loader while fetching data
                      ),
                trailing: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UploadImageScreen()),
                    );
                  },
                  child: Container(
                    height: screenSize.height * 0.1,
                    width: screenSize.height * 0.1,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(screenSize.height * 0.05),
                      // Check if the profileImageBytes is available before displaying the image
                      image: profileImageBytes != null
                          ? DecorationImage(
                              image: MemoryImage(profileImageBytes!),
                              fit: BoxFit.cover,
                            )
                          : const DecorationImage(
                              image: AssetImage('assets/dpp.jpg'),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom Grid View Section
          Container(
            height: screenSize.height * 0.7,
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Attendancepage()),
                    );
                  },
                  child: Container(
                    child: _buildGridTile(
                        screenSize, "Mark Attendance", Icons.check),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Records()));
                  },
                  child: Container(
                    child: _buildGridTile(
                        screenSize, "View Attendance", Icons.check_circle),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Helper method to create a grid tile
  Widget _buildGridTile(Size screenSize, String title, IconData icon) {
    return Container(
      height: screenSize.height * 0.07,
      width: screenSize.width * 0.07,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.red,
            size: 70,
          ),
          Boldtext(
            text: title,
            size: 22,
            color: appBarColor,
          ),
        ],
      ),
    );
  }
}
