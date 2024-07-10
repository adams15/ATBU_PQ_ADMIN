import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Create_Faculties extends StatefulWidget {
  const Create_Faculties({Key? key}) : super(key: key);
  static const String routeName = '/Create Faculties';

  @override
  State<Create_Faculties> createState() => _Create_FacultiesState();
}

class _Create_FacultiesState extends State<Create_Faculties> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _facultyName = '';
  String _departmentName = '';
  String _courseName = '';
  List<String> _testImageURLs = [];
  List<String> _examImageURLs = [];
  List<String> _solutionImageURLs = [];

  Future<void> _pickFile(String field, Function(List<String>) setURLs) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: true);

    if (result != null) {
      List<Uint8List> bytesList =
          result.files.map((file) => file.bytes!).toList();
      List<String> imageURLs = await _uploadImages(bytesList);
      setURLs(imageURLs);
    } else {
      // User canceled the picker
    }
  }

  void addFacultyToFirestore() async {
    EasyLoading.show();
    if (_formKey.currentState!.validate()) {
      try {
        // Check if faculty already exists, if not, create a new one
        DocumentSnapshot facultySnapshot =
            await _firestore.collection('Faculties').doc(_facultyName).get();
        if (!facultySnapshot.exists) {
          DocumentReference facultyRef =
              _firestore.collection('Faculties').doc(_facultyName);
          await facultyRef.set({
            'FacultyName': _facultyName,
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Faculty $_facultyName created successfully'),
            ),
          );
        }

        // Check if department exists, if not, create a new one
        DocumentSnapshot departmentSnapshot = await _firestore
            .collection('Faculties')
            .doc(_facultyName)
            .collection('Departments')
            .doc(_departmentName)
            .get();
        if (!departmentSnapshot.exists) {
          DocumentReference departmentRef = _firestore
              .collection('Faculties')
              .doc(_facultyName)
              .collection('Departments')
              .doc(_departmentName);
          await departmentRef.set({
            'DepartmentName': _departmentName,
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Department $_departmentName created successfully'),
            ),
          );
        }

        // Check if course already exists
        DocumentSnapshot courseSnapshot = await _firestore
            .collection('Faculties')
            .doc(_facultyName)
            .collection('Departments')
            .doc(_departmentName)
            .collection('Courses')
            .doc(_courseName)
            .get();
        if (courseSnapshot.exists) {
          // If course exists, update it with new image URLs
          List<String> allTestImageURLs = [
            ..._testImageURLs,
            ...(courseSnapshot['TestImageURLs'] ?? [])
          ];
          List<String> allExamImageURLs = [
            ..._examImageURLs,
            ...(courseSnapshot['ExamImageURLs'] ?? [])
          ];
          List<String> allSolutionImageURLs = [
            ..._solutionImageURLs,
            ...(courseSnapshot['SolutionImageURLs'] ?? [])
          ];

          await courseSnapshot.reference.update({
            'TestImageURLs': allTestImageURLs,
            'ExamImageURLs': allExamImageURLs,
            'SolutionImageURLs': allSolutionImageURLs,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Images updated for course $_courseName'),
            ),
          );
        } else {
          // If course doesn't exist, create it
          // Add course under the department with image URLs
          DocumentReference courseRef = departmentSnapshot.reference
              .collection('Courses')
              .doc(_courseName);
          await courseRef.set({
            'CourseName': _courseName,
            'TestImageURLs': _testImageURLs,
            'ExamImageURLs': _examImageURLs,
            'SolutionImageURLs': _solutionImageURLs,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Course $_courseName created successfully'),
            ),
          );
        }

        EasyLoading.dismiss();
        // Clear form fields
        setState(() {
          _courseName = '';
          _testImageURLs = [];
          _examImageURLs = [];
          _solutionImageURLs = [];
        });
        _formKey.currentState!.reset();
      } catch (error) {
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add course and images: $error')),
        );
      }
    }
  }

  Future<List<String>> _uploadImages(List<Uint8List> bytesList) async {
    List<String> imageURLs = [];
    for (var bytes in bytesList) {
      try {
        // Create a reference to the Firebase Storage location
        var ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('images')
            .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

        // Upload the file to Firebase Storage
        await ref.putData(bytes);

        // Get the download URL for the uploaded image
        String downloadURL = await ref.getDownloadURL();

        imageURLs.add(downloadURL);
      } catch (e) {
        print('Failed to upload image: $e');
        throw e; // Rethrow the error for handling in the calling function
      }
    }
    return imageURLs;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              child: const Center(
                child: Text(
                  'Add Course and Images',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
                ),
              ),
            ),
            const Divider(color: Colors.grey),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    _facultyName = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Faculty name cannot be empty';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Enter Faculty Name',
                  hintText: 'Faculty Name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    _departmentName = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Department name cannot be empty';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Enter Department Name',
                  hintText: 'Department Name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    _courseName = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Course name cannot be empty';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Enter Course Name',
                  hintText: 'Course Name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Upload Test Images:'),
                  SizedBox(height: 10),
                  _testImageURLs.isNotEmpty
                      ? Column(
                          children:
                              _testImageURLs.map((url) => Text(url)).toList(),
                        )
                      : ElevatedButton(
                          onPressed: () => _pickFile('test', (urls) {
                            setState(() {
                              _testImageURLs = urls;
                            });
                          }),
                          child: Text('Pick Images'),
                        ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Upload Exam Images:'),
                  SizedBox(height: 10),
                  _examImageURLs.isNotEmpty
                      ? Column(
                          children:
                              _examImageURLs.map((url) => Text(url)).toList(),
                        )
                      : ElevatedButton(
                          onPressed: () => _pickFile('exam', (urls) {
                            setState(() {
                              _examImageURLs = urls;
                            });
                          }),
                          child: Text('Pick Images'),
                        ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Upload Solution Images:'),
                  SizedBox(height: 10),
                  _solutionImageURLs.isNotEmpty
                      ? Column(
                          children: _solutionImageURLs
                              .map((url) => Text(url))
                              .toList(),
                        )
                      : ElevatedButton(
                          onPressed: () => _pickFile('solution', (urls) {
                            setState(() {
                              _solutionImageURLs = urls;
                            });
                          }),
                          child: Text('Pick Images'),
                        ),
                ],
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: addFacultyToFirestore,
                child: const Text('Add Course and Images'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
