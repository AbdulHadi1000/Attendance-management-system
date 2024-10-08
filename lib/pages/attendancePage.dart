import 'package:attdendance_management_system/colors/colors.dart';
import 'package:attdendance_management_system/pages/leavepage.dart';
import 'package:attdendance_management_system/widgets/bold_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Define a model for attendance records
class AttendanceRecord {
  final String date;
  final String status;

  AttendanceRecord({required this.date, required this.status});

  factory AttendanceRecord.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return AttendanceRecord(
      date: data['date'],
      status: data['status'],
    );
  }
}

class Attendancepage extends StatefulWidget {
  @override
  _AttendancepageState createState() => _AttendancepageState();
}

class _AttendancepageState extends State<Attendancepage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  List<AttendanceRecord> attendanceRecords = [];

  @override
  Future<void> markAttendance() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String email = user.email!;
      DateTime now = DateTime.now();
      String today = DateFormat('yyyy-MM-dd').format(now);

      var attendanceDoc = await FirebaseFirestore.instance
          .collection("attendance")
          .doc(email)
          .collection('daily')
          .doc(today)
          .get();

      if (!attendanceDoc.exists) {
        await FirebaseFirestore.instance
            .collection("attendance")
            .doc(email)
            .collection('daily')
            .doc(today)
            .set({
          'date': today,
          'status': 'present',
          'timestamp': now,
        });
        print("Attendance marked successfully!");
      } else {
        print("Attendance already marked for today.");
      }

      // Reload attendance records after marking attendance
    } else {
      print("No user is logged in.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
        ),
        backgroundColor: appBarColor,
        title: Boldtext(
          text: 'Attendance System',
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          Container(
            child: Row(
              children: [
                Boldtext(
                  text:
                      "Date : ${DateFormat('dd/MM/yyyy').format(DateTime.now())}",
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: markAttendance,
                    child: const Text('Mark Present'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LeavePage()));
                    },
                    child: const Text('Mark Leave'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
