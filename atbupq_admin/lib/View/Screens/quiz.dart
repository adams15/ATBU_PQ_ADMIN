import 'package:atbupq_admin/styles/fonts.dart';
import 'package:flutter/material.dart';

class Quiz extends StatelessWidget {
  const Quiz({super.key});
  static const String routeName = '\Quiz';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'Quiz',
            style: kbodylargeboldText,
          ),
        ),
      ),
    );
  }
}
