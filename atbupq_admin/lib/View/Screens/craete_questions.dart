import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:atbupq_admin/styles/fonts.dart';

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
  List<String> _questions = [];
  TextEditingController _questionController = TextEditingController();

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

  Future<void> _addQuestions() async {
    try {
      QuerySnapshot courseSnapshot = await _firestore
          .collection('Faculties')
          .doc(_selectedFaculty)
          .collection('Departments')
          .doc(_selectedDepartment)
          .collection('Courses')
          .where('CourseName', isEqualTo: _selectedCourse)
          .get();
      if (courseSnapshot.docs.isNotEmpty) {
        DocumentReference courseRef = courseSnapshot.docs.first.reference;
        List<String> existingQuestions =
            List.from(courseSnapshot.docs.first.get('Questions') ?? []);
        existingQuestions.addAll(_questions);
        await courseRef.update({'Questions': existingQuestions});
        EasyLoading.showSuccess('Questions added successfully');
        setState(() {
          _questions.clear();
          _questionController.clear();
        });
      } else {
        EasyLoading.showError('Course not found');
      }
    } catch (error) {
      EasyLoading.showError('Failed to add questions: $error');
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
                style: kbodylargeboldText,
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
                  return DropdownButtonFormField<String>(
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
                  );
                },
              ),
              SizedBox(height: 16),
              TextField(
                controller: _questionController,
                onChanged: (value) {
                  setState(() {
                    _questions = value.split(',').map((e) => e.trim()).toList();
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Enter Questions (Comma Separated)',
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addQuestions,
                child: Text('Add Questions'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
