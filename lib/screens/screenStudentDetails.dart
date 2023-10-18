import 'dart:io';

import 'package:flutter/material.dart';
import 'package:students_app/screens/screenUpdateStudent.dart';

import '../database/databaseHelper.dart';
import '../model/students.dart';

class ScreenStudentsDetails extends StatefulWidget {
  final Student student;

  ScreenStudentsDetails({required this.student});

  @override
  State<ScreenStudentsDetails> createState() => _ScreenStudentsDetailsState();
}

class _ScreenStudentsDetailsState extends State<ScreenStudentsDetails> {
  DatabaseHelper db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ScreenUpdateStudent(student: widget.student),
                ),
              ).then((_) => Navigator.pop(context));
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          height: 350,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 48),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              width: .5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: CircleAvatar(
                  radius: 60.0,
                  backgroundImage:
                      FileImage(File(widget.student.profilePicturePath)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 36),
                child: Text(
                  widget.student.name,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  '${widget.student.age}',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  widget.student.place,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  widget.student.mobileNumber.toString(),
                  style: const TextStyle(fontSize: 18.0),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
