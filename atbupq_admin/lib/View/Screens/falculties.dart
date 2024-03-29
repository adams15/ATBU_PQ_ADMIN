import 'package:atbupq_admin/styles/fonts.dart';
import 'package:atbupq_admin/widgets/card.dart';
import 'package:flutter/material.dart';

class Faculty extends StatelessWidget {
  const Faculty({super.key});
  static const String routeName = '\Faculties';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Faculties',
                style: kbodylargeboldText,
              ),
              //ghgjgfjftjdtdtf
            ),
          ),
          const Divider(
            color: Colors.grey,
          ),
          GridView.builder(
              shrinkWrap: true,
              itemCount: 7,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6, mainAxisSpacing: 8, crossAxisSpacing: 8),
              itemBuilder: ((context, index) {
                return card(text: 'Science', onTap: () {});
              }))
        ],
      ),
    );
  }
}
