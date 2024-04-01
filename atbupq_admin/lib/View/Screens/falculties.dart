import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Create_Faulties extends StatefulWidget {
  const Create_Faulties({Key? key}) : super(key: key);
  static const String routeName = '/Create Faculties';

  @override
  State<Create_Faulties> createState() => _Create_FaultiesState();
}

class _Create_FaultiesState extends State<Create_Faulties> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _facultyName = '';
  String _departmentName = '';
  String _courseName = '';
  List<String> _questions = [];

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
          EasyLoading.dismiss();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Course $_courseName already exists'),
            ),
          );
          return;
        }

        // Add course under the department
        DocumentReference courseRef =
            departmentSnapshot.reference.collection('Courses').doc(_courseName);
        await courseRef.set({
          'CourseName': _courseName,
          'Questions': _questions,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Course $_courseName created successfully'),
          ),
        );

        EasyLoading.dismiss();
        // Clear form fields
        setState(() {
          _courseName = '';
          _questions.clear();
        });
        _formKey.currentState!.reset();
      } catch (error) {
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add course and questions: $error')),
        );
      }
    }
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
                  'Add Course and Questions',
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
              child: TextFormField(
                onChanged: (value) {
                  // Split questions separated by comma
                  _questions = value.split(',').map((e) => e.trim()).toList();
                },
                decoration: const InputDecoration(
                  labelText: 'Enter Questions (Comma Separated)',
                  hintText: 'Question ',
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: addFacultyToFirestore,
                child: const Text('Add Course and Questions'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}








//---------------------------------------------------image own
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/services.dart';

// class Create_Faulties extends StatefulWidget {
//   const Create_Faulties({Key? key}) : super(key: key);
//   static const String routeName = '/Create Faculties';

//   @override
//   State<Create_Faulties> createState() => _Create_FaultiesState();
// }

// class _Create_FaultiesState extends State<Create_Faulties> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final ImagePicker _picker = ImagePicker();

//   String _facultyName = '';
//   String _departmentName = '';
//   String _courseName = '';
//   String _imageUrl = ''; // Store image URL

//   Future<void> addFacultyToFirestore() async {
//     EasyLoading.show();
//     if (_formKey.currentState!.validate()) {
//       try {
//         // Check if course already exists
//         DocumentSnapshot courseSnapshot = await _firestore
//             .collection('Faculties')
//             .doc(_facultyName)
//             .collection('Departments')
//             .doc(_departmentName)
//             .collection('Courses')
//             .doc(_courseName)
//             .get();
//         if (courseSnapshot.exists) {
//           EasyLoading.dismiss();
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Course $_courseName already exists'),
//             ),
//           );
//           return;
//         }

//         // Add course details including image URL to Firestore
//         DocumentReference courseRef = _firestore
//             .collection('Faculties')
//             .doc(_facultyName)
//             .collection('Departments')
//             .doc(_departmentName)
//             .collection('Courses')
//             .doc(_courseName);
//         await courseRef.set({
//           'CourseName': _courseName,
//           'ImageUrl': _imageUrl,
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Course $_courseName created successfully'),
//           ),
//         );

//         EasyLoading.dismiss();
//         // Clear form fields
//         setState(() {
//           _courseName = '';
//           _imageUrl = '';
//         });
//         _formKey.currentState!.reset();
//       } catch (error) {
//         EasyLoading.dismiss();
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to add course: $error')),
//         );
//       }
//     }
//   }

//   Future<void> pickImage() async {
//     try {
//       final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//       if (pickedFile != null) {
//         setState(() {
//           _imageUrl = pickedFile.path;
//         });
//       }
//     } on PlatformException catch (e) {
//       print("Failed to pick image: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to pick image: $e')),
//       );
//     } catch (e) {
//       print("Error picking image: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error picking image: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Form(
//         key: _formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               alignment: Alignment.topLeft,
//               padding: const EdgeInsets.all(10),
//               child: const Center(
//                 child: Text(
//                   'Add Course and Images',
//                   style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
//                 ),
//               ),
//             ),
//             const Divider(color: Colors.grey),
//             Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: TextFormField(
//                 onChanged: (value) {
//                   setState(() {
//                     _facultyName = value;
//                   });
//                 },
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Faculty name cannot be empty';
//                   }
//                   return null;
//                 },
//                 decoration: const InputDecoration(
//                   labelText: 'Enter Faculty Name',
//                   hintText: 'Faculty Name',
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: TextFormField(
//                 onChanged: (value) {
//                   setState(() {
//                     _departmentName = value;
//                   });
//                 },
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Department name cannot be empty';
//                   }
//                   return null;
//                 },
//                 decoration: const InputDecoration(
//                   labelText: 'Enter Department Name',
//                   hintText: 'Department Name',
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: TextFormField(
//                 onChanged: (value) {
//                   setState(() {
//                     _courseName = value;
//                   });
//                 },
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Course name cannot be empty';
//                   }
//                   return null;
//                 },
//                 decoration: const InputDecoration(
//                   labelText: 'Enter Course Name',
//                   hintText: 'Course Name',
//                 ),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: pickImage,
//               child: const Text('Pick Image'),
//             ),
//             if (_imageUrl.isNotEmpty) Image.network(_imageUrl),
//             Center(
//               child: ElevatedButton(
//                 onPressed: addFacultyToFirestore,
//                 child: const Text('Add Course and Image'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
