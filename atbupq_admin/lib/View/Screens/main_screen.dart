import 'package:atbupq_admin/View/Screens/craete_questions.dart';
import 'package:atbupq_admin/View/Screens/falculties.dart';
import 'package:atbupq_admin/View/Screens/banners.dart';
import 'package:atbupq_admin/styles/colors.dart';
import 'package:atbupq_admin/styles/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static const String routeName = '/Craete_Faculties';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget selectedItem = const Create_Faculties();
  screenselector(item) {
    switch (item.route) {
      case Create_Faculties.routeName:
        setState(() {
          selectedItem = const Create_Faculties();
        });
        break;
      case Add_Questions.routeName:
        setState(() {
          selectedItem = const Add_Questions();
        });
        break;
      case Banners.routeName:
        setState(() {
          selectedItem = const Banners();
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
                route: Create_Faculties.routeName),
            AdminMenuItem(
                title: 'Add Questions',
                icon: Icons.library_add,
                route: Add_Questions.routeName),
            AdminMenuItem(
                title: 'Banners',
                icon: Icons.library_add,
                route: Banners.routeName),
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
