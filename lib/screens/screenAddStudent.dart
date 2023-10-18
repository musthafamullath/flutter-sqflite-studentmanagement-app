import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../database/databaseHelper.dart';
import '../model/students.dart';

class ScreenAddStudents extends StatefulWidget {
  final DatabaseHelper databaseHelper;

  ScreenAddStudents({required this.databaseHelper});

  @override
  _ScreenAddStudentsState createState() => _ScreenAddStudentsState();
}

class _ScreenAddStudentsState extends State<ScreenAddStudents> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _placeController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  String? _profilePicturePath;
  XFile? image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add Student'),
        backgroundColor: Colors.green[900],
        toolbarHeight: 60,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: 500,
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                width: .5,
              ),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      bottomSheet(context);
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _profilePicturePath != null
                          ? FileImage(File(_profilePicturePath!))
                          : null,
                      child: _profilePicturePath == null
                          ? const Icon(Icons.add_a_photo)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter the name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextFormField(
                      controller: _ageController,
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter the age';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextFormField(
                      controller: _placeController,
                      decoration: const InputDecoration(
                        labelText: 'Place',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter the place';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextFormField(
                      controller: _mobileNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Mobile Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter the mobile number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('Save'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final name = _nameController.text;
                        final place = _placeController.text;
                        final age = int.parse(_ageController.text);
                        final mobileNumber =
                            int.parse(_mobileNumberController.text);
                        final student = Student(
                          id: 0,
                          name: name,
                          age: age,
                          place: place,
                          mobileNumber: mobileNumber,
                          profilePicturePath: _profilePicturePath ?? '', domain: null,
                        );
                        widget.databaseHelper.insertStudent(student).then((id) {
                          if (id > 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Student added successfully'),
                                backgroundColor: Colors.green[200],
                                duration: const Duration(seconds: 3),
                              ),
                            );
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Failed to add student'),
                                backgroundColor: Colors.red[200],
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              width: .4,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              const Text(
                'Select the image source:',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      XFile? img = await ImagePicker()
                          .pickImage(source: ImageSource.camera);
                      setState(() {
                        image = img;
                      });
                      _profilePicturePath = image!.path;
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.camera,
                    ),
                    label: const Text(
                      'Camera',
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      XFile? img = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      setState(() {
                        image = img;
                      });
                      _profilePicturePath = image!.path;
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.image,
                    ),
                    label: const Text(
                      'Gallery',
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
