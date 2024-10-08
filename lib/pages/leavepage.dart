import 'package:attdendance_management_system/colors/colors.dart';
import 'package:attdendance_management_system/widgets/bold_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class LeavePage extends StatelessWidget {
  LeavePage({super.key});

  TextEditingController _leaverequest = TextEditingController();

  // Function to send leave request
  Future<void> sendLeaveRequest(String reason) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;

    if (user != null) {
      DateTime now = DateTime.now();
      String email = user.email!;
      String today = DateFormat('yyyy-MM-dd').format(now);

      // Check if attendance or leave request already exists for today
      DocumentSnapshot attendanceDoc = await FirebaseFirestore.instance
          .collection("attendance")
          .doc(email)
          .collection('daily')
          .doc(today)
          .get();

      if (attendanceDoc.exists) {
        print("Attendance or leave request already exists for today.");
      } else {
        // Add a leave request document for today
        await FirebaseFirestore.instance
            .collection("attendance")
            .doc(email)
            .collection('daily')
            .doc(today)
            .set({
          'date': today,
          'type': 'leaveRequest',
          'reason': reason,
          'status': 'pending',
        });

        print("Leave request submitted successfully.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Boldtext(
          text: "Request a Leave",
          color: Colors.white,
        ),
        backgroundColor: appBarColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _leaverequest, // Bind the TextEditingController
              maxLength: 2000,
              decoration: InputDecoration(
                hintText: "Enter Your Request",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: appBarColor, width: 5),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.1,
            ),
            GestureDetector(
              onTap: () {
                if (_leaverequest.text.isNotEmpty) {
                  sendLeaveRequest(_leaverequest.text); // Call the function
                } else {
                  print("Please enter a leave request.");
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: appBarColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Boldtext(
                    text: 'Send Request',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
