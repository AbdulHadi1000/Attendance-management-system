import 'package:attdendance_management_system/colors/colors.dart';
import 'package:attdendance_management_system/widgets/bold_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Model class for AttendanceRecord
class AttendanceRecord {
  final String date;
  final String status;

  AttendanceRecord({required this.date, required this.status});

  factory AttendanceRecord.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AttendanceRecord(
      date: data['date'] ?? '',
      status: data['status'] ?? '',
    );
  }
}

class Records extends StatefulWidget {
  const Records({super.key});

  @override
  State<Records> createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  List<AttendanceRecord> attendanceRecords = [];

  @override
  void initState() {
    super.initState();
    _loadAttendanceRecords();
  }

  Future<void> _loadAttendanceRecords() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String userId = user.email!;

      QuerySnapshot attendanceSnapshot = await FirebaseFirestore.instance
          .collection('attendance')
          .doc(userId)
          .collection('daily')
          .get();

      List<AttendanceRecord> records = attendanceSnapshot.docs
          .map((doc) => AttendanceRecord.fromFirestore(doc))
          .toList();

      setState(() {
        attendanceRecords = records;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: appBarColor,
        title: Boldtext(
          text: "Attendance Records",
          color: Colors.white,
        ),
      ),
      body: attendanceRecords.isNotEmpty
          ? ListView.builder(
              itemCount: attendanceRecords.length,
              itemBuilder: (context, index) {
                final record = attendanceRecords[index];
                return ListTile(
                  title: Text(record.date),
                  subtitle: Text('Status: ${record.status}'),
                );
              },
            )
          : const Center(
              child: Text('No attendance records found'),
            ),
    );
  }
}
