import 'package:flutter/material.dart';

import '../widgets/app_text.dart';

showMsg(BuildContext context, String msg, Color bgColor) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: bgColor,
      content: AppText(
        text: msg,
        textAlign: TextAlign.center,
        color: Colors.white,
      ),
      duration: const Duration(seconds: 3),
      dismissDirection: DismissDirection.down,
    ),
  );
}

showInternetConnectionErroMsg(BuildContext context) => showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        content: AppText(text: 'Please check your internet connection!'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Center(
                child: AppText(
              text: 'Okay',
              color: Colors.white,
            )),
          ),
        ],
      );
    });
