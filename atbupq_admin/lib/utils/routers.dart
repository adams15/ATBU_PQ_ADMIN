import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PageNavigator {
  PageNavigator({this.context});
  BuildContext? context;

  Future nextPage({Widget? page}) {
    return Navigator.push(
        context!, CupertinoPageRoute(builder: ((context) => page!)));
  }

  void nextPageOnly({Widget? page}) {
    Navigator.pushAndRemoveUntil(context!,
        MaterialPageRoute(builder: (context) => page!), (route) => false);
  }
}
