import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../database/databaseHelper.dart';
import '../model/students.dart';

class ScreenUpdateStudent extends StatefulWidget {
  final Student student;

  ScreenUpdateStudent({required this.student});

  @override
  _ScreenUpdateStudentState createState() => _ScreenUpdateStudentState();
}

class _ScreenUpdateStudentState extends State<ScreenUpdateStudent> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _placeController = TextEditingController();
  final _mobileNumberController = TextEditingController();

  String? _profilePicturePath;
  XFile? image;

  DatabaseHelper datahelp = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.student.name;
    _ageController.text = widget.student.age.toString();
    _placeController.text = widget.student.place;
    _mobileNumberController.text = widget.student.mobileNumber.toString();
    _profilePicturePath = widget.student.profilePicturePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Update Students'),
      ),
      body: Center(
        child: Container(
          height: 500,
          width: double.infinity,
          margin:const EdgeInsets.all(16),
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
                InkWell(
                  onTap: (){
                    bottomSheet(context);
                  },
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundImage:
                        FileImage(File(_profilePicturePath!)),
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
                      labelText: 'MobileNumber',
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
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                  onPressed: () {
                    editStudent();
                  },
                ),
              ],
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

  editStudent() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final age = int.parse(_ageController.text);
      final place = _placeController.text;
      final mobileNumber = int.parse(_mobileNumberController.text);

      final updatedStudent = Student(
        id: widget.student.id,
        name: name,
        age: age,
        place: place,
        mobileNumber: mobileNumber,
        profilePicturePath: _profilePicturePath!, domain: null,
      );
      datahelp.updateStudent(updatedStudent).then((id) {
        if (id > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Student updated successfully')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update student')),
          );
        }
      });
    }
  }
}
