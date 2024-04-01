import 'package:atbupq_admin/View/Screens/craete_questions.dart';
import 'package:atbupq_admin/View/Screens/falculties.dart';
import 'package:atbupq_admin/View/Screens/quiz.dart';
import 'package:atbupq_admin/styles/colors.dart';
import 'package:atbupq_admin/styles/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget selectedItem = const Create_Faulties();
  screenselector(item) {
    switch (item.route) {
      case Create_Faulties.routeName:
        setState(() {
          selectedItem = const Create_Faulties();
        });
        break;
      case Add_Questions.routeName:
        setState(() {
          selectedItem = const Add_Questions();
        });
        break;
      case Quiz.routeName:
        setState(() {
          selectedItem = const Quiz();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(
            'Admin Panel',
            style: kbodysmallwhitecolor,
          ),
        ),
        sideBar: SideBar(
          items: const [
            AdminMenuItem(
                title: 'Create Faculties',
                icon: Icons.library_add,
                route: Create_Faulties.routeName),
            AdminMenuItem(
                title: 'Add Questions',
                icon: Icons.library_add,
                route: Add_Questions.routeName),
            AdminMenuItem(
                title: 'Quiz', icon: Icons.library_add, route: Quiz.routeName),
          ],
          selectedRoute: '/',
          onSelected: (item) {
            screenselector(item);
          },
          header: Container(
            height: 50,
            width: double.infinity,
            color: const Color(0xff444444),
            child: const Center(
              child: Text(
                'Category',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        body: selectedItem);
  }
}
