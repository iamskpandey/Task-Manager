import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:todo_app/services/user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<void> signUpWithEmailAndPassword(
      {required String name,
      required String email,
      required String password,
      required BuildContext context}) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      final id = userCredential.user!.uid;
      await UserService().saveNewUser(
        id: id,
        name: name,
        email: email,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Signup successful!',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.amber[200],
        ),
      );
      await _auth.signOut();

      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showInfo(context, 'Email already in use');
      } else if (e.code == 'weak-password') {
        showInfo(context, 'Password is too weak');
      } else if (e.code == 'no-internet') {
        showInfo(context, 'No internet connection');
      } else {
        showInfo(context, e.code.replaceAll('-', ' '));
      }
    } catch (e) {
      showInfo(context, 'An error occurred');
    }
  }

  Future<void> signInWithEmailAndPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      Navigator.pushReplacementNamed(context, '/homepage');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showInfo(context, 'Invalid email or password');
      } else if (e.code == 'wrong-password') {
        showInfo(context, 'Invalid email or password');
      } else if (e.code == 'no-internet') {
        showInfo(context, 'No internet connection');
      } else if (e.code == 'invalid-credential') {
        showInfo(context, 'Invalid email or password');
      } else {
        showInfo(context, e.code.replaceAll('-', ' '));
      }
    } catch (e) {
      showInfo(context, 'Incorrect email or password');
    }
  }

  Future<void> signOut({required BuildContext context}) async {
    await _auth.signOut();

    Navigator.pushReplacementNamed(context, '/splash');
  }

  void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.amber[200],
        content: Text(message, style: const TextStyle(color: Colors.black)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
