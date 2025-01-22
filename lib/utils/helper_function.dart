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
