import 'package:atbupq_admin/styles/colors.dart';
import 'package:atbupq_admin/styles/fonts.dart';
import 'package:flutter/material.dart';

class card extends StatelessWidget {
  String text;
  void Function()? onTap;
  card({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 82,
        width: 112,
        child: Card(
          color: boneWhite,
          elevation: 3,
          shadowColor: blackColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/books.png'),
              Text(
                text,
                style: kbodysmallblackcolor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
