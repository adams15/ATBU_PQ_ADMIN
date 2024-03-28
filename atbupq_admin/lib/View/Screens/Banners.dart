import 'package:atbupq_admin/styles/fonts.dart';
import 'package:flutter/material.dart';

class Banners extends StatelessWidget {
  const Banners({super.key});
  static const String routeName = '\Banners';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'Banners',
            style: kbodylargeboldText,
          ),
        ),
      ),
    );
  }
}
