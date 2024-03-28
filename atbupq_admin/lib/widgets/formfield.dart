import 'package:atbupq_admin/styles/colors.dart';
import 'package:atbupq_admin/styles/fonts.dart';
import 'package:flutter/material.dart';

Widget customTextField({
  Widget? prefix,
  Color? color,
  String? hint,
  TextEditingController? controller,
}) {
  return Column(
    children: [
      Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: primaryColor),
          color: whiteColor,
        ),
        child: TextFormField(
          controller: controller,
          //maxLines: maxLines,
          decoration: InputDecoration(
              prefixIcon: prefix,
              prefixIconColor: color,
              // ignore: prefer_const_constructors
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide.none,
              ),
              hintText: hint,
              border: InputBorder.none),
        ),
      )
    ],
  );
}

// password
Widget passwordTextField({
  Widget? prefix,
  Widget? suffix,
  Color? color,
  String? hint,
  TextEditingController? controller,
}) {
  return Column(
    children: [
      Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: primaryColor),
          color: whiteColor,
        ),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
              suffixIcon: suffix,
              suffixIconColor: color,
              prefixIcon: prefix,
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide.none,
              ),
              prefixIconColor: color,
              hintText: hint,
              hintStyle: kbodysmallgreycolor,
              border: InputBorder.none),
        ),
      )
    ],
  );
}
