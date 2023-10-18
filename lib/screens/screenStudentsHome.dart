import 'dart:io';

import 'package:flutter/material.dart';
import 'package:students_app/screens/screenAddStudent.dart';
import 'package:students_app/screens/screenStudentDetails.dart';
import 'package:students_app/screens/screenUpdateStudent.dart';

import '../database/databaseHelper.dart';
import '../model/students.dart';

class ScreenStudentsHome extends StatefulWidget {
  @override
  _ScreenStudentsHomeState createState() => _ScreenStudentsHomeState();
}

class _ScreenStudentsHomeState extends State<ScreenStudentsHome> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Student> students = [];
  List<Student> filteredStudents = [];
  bool isSearching = false;

  @override
  void initState() {
    _refreshStudentList();
    super.initState();
  }

  Future<void> _refreshStudentList() async {
    final studentList = await databaseHelper.getStudents();
    setState(() {
      students = studentList;
      filteredStudents = studentList;
    });
  }

  void _filterStudents(String query) {
    setState(
      () {
        if (query.isEmpty) {
          filteredStudents = students;
        } else {
          filteredStudents = students
              .where(
                (student) => student.name.toLowerCase().contains(
                      query.toLowerCase(),
                    ),
              )
              .toList();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isSearching
            ? const Text('Student List')
            : TextField(
                style: const TextStyle(color: Colors.white),
                onChanged: (query) {
                  _filterStudents(query);
                },
                decoration: const InputDecoration(
                  hintText: 'Search student here',
                  hintStyle: TextStyle(color: Colors.white),
                  focusColor: Colors.white,
                ),
              ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  filteredStudents = students;
                }
              });
            },
            icon: const Icon(Icons.search),
          ),
        ],
        backgroundColor: Colors.green[900],
        toolbarHeight: 60,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      body: filteredStudents.isEmpty
          ? const Center(
              child: Text('No students found.'),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: filteredStudents.length,
              itemBuilder: (context, index) {
                final student = filteredStudents[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ScreenStudentsDetails(student: student),
                      ),
                    ).then((value) => _refreshStudentList());
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        width: .5,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () {
                              deleteStudent(context, student.id);
                            },
                            icon: const Icon(Icons.delete_rounded),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) =>
                                      ScreenUpdateStudent(student: student),
                                ),
                              ).then((_) => _refreshStudentList());
                            },
                            icon: const Icon(Icons.edit),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    FileImage(File(student.profilePicturePath)),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                student.name,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ScreenAddStudents(databaseHelper: databaseHelper),
            ),
          ).then((_) => _refreshStudentList());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  deleteStudent(BuildContext ctx, int id) {
    showDialog(
      context: ctx,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Student'),
        content: const Text('Are you sure you want to delete this student?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(ctx);
            },
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              databaseHelper
                  .deleteStudent(id)
                  .then((value) => _refreshStudentList());
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }
}
