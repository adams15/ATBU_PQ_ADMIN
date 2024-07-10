// import 'dart:html';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'dart:convert';

// class Add_Questions extends StatefulWidget {
//   const Add_Questions({Key? key}) : super(key: key);
//   static const String routeName = '/Add Questions';

//   @override
//   _Add_QuestionsState createState() => _Add_QuestionsState();
// }

// class _Add_QuestionsState extends State<Add_Questions> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   late String _selectedFaculty;
//   late String _selectedDepartment;
//   late String _selectedCourse;
//   List<String> _courses = [];
//   String _selectedQuestionType = 'Test';
//   String? _imageUrl;
//   TextEditingController _questionController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _fetchFaculties();
//   }

//   Future<void> _fetchFaculties() async {
//     try {
//       QuerySnapshot querySnapshot =
//           await _firestore.collection('Faculties').get();
//       setState(() {
//         _selectedFaculty = querySnapshot.docs.first.get('FacultyName');
//       });
//       _fetchDepartments();
//     } catch (error) {
//       print('Error fetching faculties: $error');
//     }
//   }

//   Future<void> _fetchDepartments() async {
//     try {
//       QuerySnapshot querySnapshot = await _firestore
//           .collection('Faculties')
//           .doc(_selectedFaculty)
//           .collection('Departments')
//           .get();
//       setState(() {
//         _selectedDepartment = querySnapshot.docs.first.get('DepartmentName');
//       });
//       _fetchCourses();
//     } catch (error) {
//       print('Error fetching departments: $error');
//     }
//   }

//   Future<void> _fetchCourses() async {
//     try {
//       QuerySnapshot querySnapshot = await _firestore
//           .collection('Faculties')
//           .doc(_selectedFaculty)
//           .collection('Departments')
//           .doc(_selectedDepartment)
//           .collection('Courses')
//           .get();
//       setState(() {
//         _courses = querySnapshot.docs
//             .map((doc) => doc.get('CourseName') as String)
//             .toList();
//         if (_courses.isNotEmpty) {
//           _selectedCourse = _courses.first;
//         }
//       });
//     } catch (error) {
//       print('Error fetching courses: $error');
//     }
//   }

//   Future<void> _pickImage() async {
//     FilePickerResult? result =
//         await FilePicker.platform.pickFiles(type: FileType.image);

//     if (result != null) {
//       final file = result.files.single;
//       final dataUrl = 'data:image/${file.extension};base64,' +
//           base64Encode(Uint8List.fromList(file.bytes!));
//       setState(() {
//         _imageUrl = dataUrl;
//       });
//     } else {
//       // User canceled the picker
//     }
//   }

//   Future<void> _addQuestions() async {
//     try {
//       print('Adding questions...');
//       QuerySnapshot courseSnapshot = await _firestore
//           .collection('Faculties')
//           .doc(_selectedFaculty)
//           .collection('Departments')
//           .doc(_selectedDepartment)
//           .collection('Courses')
//           .where('CourseName', isEqualTo: _selectedCourse)
//           .get();
//       if (courseSnapshot.docs.isNotEmpty) {
//         DocumentReference courseRef = courseSnapshot.docs.first.reference;

//         // Get existing image URLs for the selected question type
//         List<dynamic>? existingImageURLs =
//             courseSnapshot.docs.first.get('${_selectedQuestionType}ImageURLs');
//         List<String> imageUrls = existingImageURLs != null
//             ? List<String>.from(existingImageURLs)
//             : [];
//         print('Existing image URLs: $imageUrls');

//         // Upload new question image if available
//         if (_imageUrl != null) {
//           String? questionImageURL = await _uploadImage(_imageUrl!);
//           print('Uploaded image URL: $questionImageURL');
//           imageUrls.add(questionImageURL!);
//           print('Updated image URLs: $imageUrls');

//           // Save the updated image URLs to Firestore
//           await courseRef.update({
//             '${_selectedQuestionType}ImageURLs': imageUrls,
//           });

//           EasyLoading.showSuccess('Question added successfully');
//           setState(() {
//             _imageUrl = null; // Clear the image after uploading
//             _questionController.clear();
//           });
//         } else {
//           EasyLoading.showError('Please upload an image');
//         }
//       } else {
//         EasyLoading.showError('Course not found');
//       }
//     } catch (error) {
//       EasyLoading.showError('Failed to add question: $error');
//     }
//   }

//   Future<String> _uploadImage(String imageUrl) async {
//     try {
//       // Create a reference to the Firebase Storage location
//       var ref = firebase_storage.FirebaseStorage.instance
//           .ref()
//           .child('images')
//           .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

//       // Convert data URL to bytes
//       final data = imageUrl.split(',').last;
//       final Uint8List bytes = base64Decode(data);

//       // Upload the bytes to Firebase Storage
//       await ref.putData(bytes);

//       // Get the download URL for the uploaded image
//       String downloadURL = await ref.getDownloadURL();

//       return downloadURL;
//     } catch (e) {
//       print('Failed to upload image: $e');
//       throw e; // Rethrow the error for handling in the calling function
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Container(
//         alignment: Alignment.topLeft,
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Create Questions',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 16),
//               FutureBuilder<QuerySnapshot>(
//                 future: _firestore.collection('Faculties').get(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return CircularProgressIndicator();
//                   }
//                   if (snapshot.hasError) {
//                     return Text('Error: ${snapshot.error}');
//                   }
//                   List<DropdownMenuItem<String>> items =
//                       snapshot.data!.docs.map((doc) {
//                     return DropdownMenuItem<String>(
//                       value: doc['FacultyName'] as String,
//                       child: Text(doc['FacultyName'] as String),
//                     );
//                   }).toList();
//                   return DropdownButtonFormField<String>(
//                     value: _selectedFaculty,
//                     onChanged: (newValue) {
//                       setState(() {
//                         _selectedFaculty = newValue!;
//                       });
//                       _fetchDepartments();
//                     },
//                     items: items,
//                     decoration: InputDecoration(labelText: 'Select Faculty'),
//                   );
//                 },
//               ),
//               SizedBox(height: 16),
//               FutureBuilder<QuerySnapshot>(
//                 future: _firestore
//                     .collection('Faculties')
//                     .doc(_selectedFaculty)
//                     .collection('Departments')
//                     .get(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return CircularProgressIndicator();
//                   }
//                   if (snapshot.hasError) {
//                     return Text('Error: ${snapshot.error}');
//                   }
//                   List<DropdownMenuItem<String>> items =
//                       snapshot.data!.docs.map((doc) {
//                     return DropdownMenuItem<String>(
//                       value: doc['DepartmentName'] as String,
//                       child: Text(doc['DepartmentName'] as String),
//                     );
//                   }).toList();
//                   return DropdownButtonFormField<String>(
//                     value: _selectedDepartment,
//                     onChanged: (newValue) {
//                       setState(() {
//                         _selectedDepartment = newValue!;
//                       });
//                       _fetchCourses();
//                     },
//                     items: items,
//                     decoration: InputDecoration(labelText: 'Select Department'),
//                   );
//                 },
//               ),
//               SizedBox(height: 16),
//               FutureBuilder<QuerySnapshot>(
//                 future: _firestore
//                     .collection('Faculties')
//                     .doc(_selectedFaculty)
//                     .collection('Departments')
//                     .doc(_selectedDepartment)
//                     .collection('Courses')
//                     .get(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return CircularProgressIndicator();
//                   }
//                   if (snapshot.hasError) {
//                     return Text('Error: ${snapshot.error}');
//                   }
//                   List<String> courses = snapshot.data!.docs.map((doc) {
//                     return doc['CourseName'] as String;
//                   }).toList();
//                   return DropdownButtonFormField<String>(
//                     value: _selectedCourse,
//                     onChanged: (newValue) {
//                       setState(() {
//                         _selectedCourse = newValue!;
//                       });
//                     },
//                     items: courses.map((course) {
//                       return DropdownMenuItem<String>(
//                         value: course,
//                         child: Text(course),
//                       );
//                     }).toList(),
//                     decoration: InputDecoration(labelText: 'Select Course'),
//                   );
//                 },
//               ),
//               SizedBox(height: 16),
//               DropdownButtonFormField<String>(
//                 value: _selectedQuestionType,
//                 onChanged: (newValue) {
//                   setState(() {
//                     _selectedQuestionType = newValue!;
//                   });
//                 },
//                 items: ['Test', 'Exam', 'Solution'].map((type) {
//                   return DropdownMenuItem<String>(
//                     value: type,
//                     child: Text(type),
//                   );
//                 }).toList(),
//                 decoration: InputDecoration(labelText: 'Select Question Type'),
//               ),
//               SizedBox(height: 16),
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 16.0),
//                 child: Row(
//                   children: [
//                     Text('Upload Question Image:'),
//                     SizedBox(width: 16),
//                     _imageUrl != null
//                         ? Image.network(
//                             _imageUrl!,
//                             width: 100,
//                             height: 100,
//                             fit: BoxFit.cover,
//                           )
//                         : ElevatedButton(
//                             onPressed: _pickImage,
//                             child: Text('Pick Image'),
//                           ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: _addQuestions,
//                 child: Text('Add Question'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

////////////////////////////////////////////

import 'dart:html';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:convert';

class Add_Questions extends StatefulWidget {
  const Add_Questions({Key? key}) : super(key: key);
  static const String routeName = '/Add Questions';

  @override
  _Add_QuestionsState createState() => _Add_QuestionsState();
}

class _Add_QuestionsState extends State<Add_Questions> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String _selectedFaculty;
  late String _selectedDepartment;
  late String _selectedCourse;
  List<String> _courses = [];
  String _selectedQuestionType = 'Test';
  String? _imageUrl;
  TextEditingController _questionController = TextEditingController();
  TextEditingController _newCourseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchFaculties();
  }

  Future<void> _fetchFaculties() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('Faculties').get();
      setState(() {
        _selectedFaculty = querySnapshot.docs.first.get('FacultyName');
      });
      _fetchDepartments();
    } catch (error) {
      print('Error fetching faculties: $error');
    }
  }

  Future<void> _fetchDepartments() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('Faculties')
          .doc(_selectedFaculty)
          .collection('Departments')
          .get();
      setState(() {
        _selectedDepartment = querySnapshot.docs.first.get('DepartmentName');
      });
      _fetchCourses();
    } catch (error) {
      print('Error fetching departments: $error');
    }
  }

  Future<void> _fetchCourses() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('Faculties')
          .doc(_selectedFaculty)
          .collection('Departments')
          .doc(_selectedDepartment)
          .collection('Courses')
          .get();
      setState(() {
        _courses = querySnapshot.docs
            .map((doc) => doc.get('CourseName') as String)
            .toList();
        if (_courses.isNotEmpty) {
          _selectedCourse = _courses.first;
        }
      });
    } catch (error) {
      print('Error fetching courses: $error');
    }
  }

  Future<void> _pickImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      final file = result.files.single;
      final dataUrl = 'data:image/${file.extension};base64,' +
          base64Encode(Uint8List.fromList(file.bytes!));
      setState(() {
        _imageUrl = dataUrl;
      });
    } else {
      // User canceled the picker
    }
  }

  Future<void> _addCourse() async {
    try {
      if (_newCourseController.text.isEmpty) {
        EasyLoading.showError('Please enter a course name');
        return;
      }

      DocumentReference departmentRef = _firestore
          .collection('Faculties')
          .doc(_selectedFaculty)
          .collection('Departments')
          .doc(_selectedDepartment)
          .collection('Courses')
          .doc(_newCourseController.text); // Use course name as document ID

      await departmentRef.set({
        'CourseName': _newCourseController.text,
        'ExamImageURLs': [],
        'SolutionImageURLs': [],
        'TestImageURLs': [],
      });

      EasyLoading.showSuccess('Course added successfully');
      _fetchCourses(); // Refresh the course list
      _newCourseController.clear(); // Clear the input field
    } catch (error) {
      EasyLoading.showError('Failed to add course: $error');
    }
  }

  Future<void> _addQuestions() async {
    try {
      print('Adding questions...');
      DocumentReference courseRef = _firestore
          .collection('Faculties')
          .doc(_selectedFaculty)
          .collection('Departments')
          .doc(_selectedDepartment)
          .collection('Courses')
          .doc(_selectedCourse); // Use selected course name

      // Get existing image URLs for the selected question type
      DocumentSnapshot courseSnapshot = await courseRef.get();
      if (courseSnapshot.exists) {
        List<dynamic>? existingImageURLs =
            courseSnapshot.get('${_selectedQuestionType}ImageURLs');
        List<String> imageUrls = existingImageURLs != null
            ? List<String>.from(existingImageURLs)
            : [];
        print('Existing image URLs: $imageUrls');

        // Upload new question image if available
        if (_imageUrl != null) {
          String? questionImageURL = await _uploadImage(_imageUrl!);
          print('Uploaded image URL: $questionImageURL');
          imageUrls.add(questionImageURL!);
          print('Updated image URLs: $imageUrls');

          // Save the updated image URLs to Firestore
          await courseRef.update({
            '${_selectedQuestionType}ImageURLs': imageUrls,
          });

          EasyLoading.showSuccess('Question added successfully');
          setState(() {
            _imageUrl = null; // Clear the image after uploading
            _questionController.clear();
          });
        } else {
          EasyLoading.showError('Please upload an image');
        }
      } else {
        EasyLoading.showError('Course not found');
      }
    } catch (error) {
      EasyLoading.showError('Failed to add question: $error');
    }
  }

  Future<String> _uploadImage(String imageUrl) async {
    try {
      // Create a reference to the Firebase Storage location
      var ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Convert data URL to bytes
      final data = imageUrl.split(',').last;
      final Uint8List bytes = base64Decode(data);

      // Upload the bytes to Firebase Storage
      await ref.putData(bytes);

      // Get the download URL for the uploaded image
      String downloadURL = await ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      print('Failed to upload image: $e');
      throw e; // Rethrow the error for handling in the calling function
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Questions',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              FutureBuilder<QuerySnapshot>(
                future: _firestore.collection('Faculties').get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  List<DropdownMenuItem<String>> items =
                      snapshot.data!.docs.map((doc) {
                    return DropdownMenuItem<String>(
                      value: doc['FacultyName'] as String,
                      child: Text(doc['FacultyName'] as String),
                    );
                  }).toList();
                  return DropdownButtonFormField<String>(
                    value: _selectedFaculty,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedFaculty = newValue!;
                      });
                      _fetchDepartments();
                    },
                    items: items,
                    decoration: InputDecoration(labelText: 'Select Faculty'),
                  );
                },
              ),
              SizedBox(height: 16),
              FutureBuilder<QuerySnapshot>(
                future: _firestore
                    .collection('Faculties')
                    .doc(_selectedFaculty)
                    .collection('Departments')
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  List<DropdownMenuItem<String>> items =
                      snapshot.data!.docs.map((doc) {
                    return DropdownMenuItem<String>(
                      value: doc['DepartmentName'] as String,
                      child: Text(doc['DepartmentName'] as String),
                    );
                  }).toList();
                  return DropdownButtonFormField<String>(
                    value: _selectedDepartment,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedDepartment = newValue!;
                      });
                      _fetchCourses();
                    },
                    items: items,
                    decoration: InputDecoration(labelText: 'Select Department'),
                  );
                },
              ),
              SizedBox(height: 16),
              FutureBuilder<QuerySnapshot>(
                future: _firestore
                    .collection('Faculties')
                    .doc(_selectedFaculty)
                    .collection('Departments')
                    .doc(_selectedDepartment)
                    .collection('Courses')
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  List<String> courses = snapshot.data!.docs.map((doc) {
                    return doc['CourseName'] as String;
                  }).toList();
                  return Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedCourse,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCourse = newValue!;
                          });
                        },
                        items: courses.map((course) {
                          return DropdownMenuItem<String>(
                            value: course,
                            child: Text(course),
                          );
                        }).toList(),
                        decoration: InputDecoration(labelText: 'Select Course'),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _newCourseController,
                        decoration: InputDecoration(
                          labelText: 'New Course Name',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: _addCourse,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedQuestionType,
                onChanged: (newValue) {
                  setState(() {
                    _selectedQuestionType = newValue!;
                  });
                },
                items: ['Test', 'Exam', 'Solution'].map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Select Question Type'),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  children: [
                    Text('Upload Question Image:'),
                    SizedBox(width: 16),
                    _imageUrl != null
                        ? Image.network(
                            _imageUrl!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : ElevatedButton(
                            onPressed: _pickImage,
                            child: Text('Pick Image'),
                          ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addQuestions,
                child: Text('Add Question'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
