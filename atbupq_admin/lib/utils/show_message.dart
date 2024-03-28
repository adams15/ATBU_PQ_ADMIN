import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

suceesMessage(BuildContext context) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      content: Container(
        padding: const EdgeInsets.all(12),
        height: 80,
        decoration: const BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 40,
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Success',
                  style: GoogleFonts.rubik(
                      textStyle: const TextStyle(
                          color: Colors.white,
                          letterSpacing: .5,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
                Text(
                  'Account has been created',
                  style: GoogleFonts.rubik(
                      textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  )),
                ),
              ],
            ))
          ],
        ),
      )));
}

// failure
errorMessage(BuildContext context, String messageOne, String messagetwo) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      content: Container(
        padding: const EdgeInsets.all(12),
        height: 80,
        decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Row(
          children: [
            const Icon(
              Icons.cancel,
              color: Colors.white,
              size: 40,
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  messageOne,
                  style: GoogleFonts.rubik(
                      textStyle: const TextStyle(
                          color: Colors.white,
                          letterSpacing: .5,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
                Text(
                  messagetwo,
                  style: GoogleFonts.rubik(
                      textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  )),
                ),
              ],
            ))
          ],
        ),
      )));
}
