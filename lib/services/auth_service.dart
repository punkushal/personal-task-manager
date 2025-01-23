import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_task_manager/models/user.dart';

import '../utils/helper_function.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  Future<void> createUserWithEmailAndPassword(
      String email, String password, String name, BuildContext context) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final uid = userCredential.user!.uid;

      //Store individual user personal data inside users collection
      db
          .collection('users')
          .doc(uid)
          .set(UserModel(email: email, uid: uid, name: name).toMap());
    } on FirebaseAuthException catch (e) {
      String msg = "An error occurred during registration";
      if (e.code == 'weak-password') {
        msg = 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        msg = 'An account already exists for this email';
      }
      if (context.mounted) {
        showMsg(context, msg, Colors.red);
        return;
      }
    } catch (e) {
      if (context.mounted) {
        showMsg(context, 'Registration failed ${e.toString()}', Colors.red);
      }
    }
    if (context.mounted) {
      showMsg(
        context,
        'successfully registered',
        Colors.green,
      );
    }
  }

  //To login
  Future<void> loginUser(
      String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // if (context.mounted) {
      //   Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(
      //         builder: (ctx) => HomeScreen(),
      //       ));
      // }
    } on FirebaseAuthException catch (e) {
      String msg = e.code;
      if (e.code == 'invalid-email') {
        msg = 'The email provided is invalid';
      } else if (e.code == 'user-disabled') {
        msg = 'This email has been disabled';
      } else if (e.code == 'user-not-found') {
        msg = 'With this email user not found';
      } else if (e.code == 'wrong-password') {
        msg = 'You entered wrong password';
      }
      if (context.mounted) {
        showMsg(context, msg, Colors.red);
        return;
      }
    } catch (e) {
      if (context.mounted) {
        showMsg(context, 'Login failed ${e.toString()}', Colors.red);
      }
    }
    if (context.mounted) {
      showMsg(
        context,
        'successfully logged in',
        Colors.green,
      );
    }
  }
}
