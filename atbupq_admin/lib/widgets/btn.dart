import 'package:atbupq_admin/styles/colors.dart';
import 'package:atbupq_admin/styles/fonts.dart';
import 'package:flutter/material.dart';

Widget btn({
  VoidCallback? onTap,
  bool? status = false,
  String? text = 'save',
}) {
  return GestureDetector(
    onTap: status == true ? null : onTap,
    child: Container(
      height: 60,
      margin: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: status == false ? primaryColor : coolGreyColor,
          borderRadius: BorderRadius.circular(8)),
      width: double.infinity,
      child: Text(status == false ? text! : 'Please wait...', style: kbtnText),
    ),
  );
}

Widget outlinebtn({
  Widget? child,
  VoidCallback? onTap,
  bool? status = false,
  String? text = 'save',
}) {
  return GestureDetector(
    onTap: status == true ? null : onTap,
    child: Container(
      height: 60,
      margin: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(8)),
      width: double.infinity,
      child: Text(status == false ? text! : 'Please wait...',
          style: kbodysmallbold),
    ),
  );
}
