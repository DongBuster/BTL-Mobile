import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/services/auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: GestureDetector(
        onTap: () async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();

          await Auth.signOut().then((value) {
            prefs.setBool('islogin', false);
            prefs.setString('email', '');
            // print(prefs.getBool('islogin'));
          }).catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          });
          if (context.mounted) {
            context.go('/login');
          }
        },
        child: Container(
          // color: Colors.green,
          child: const Text('logout'),
        ),
      )),
    );
  }
}

final snackBar = SnackBar(
  elevation: 0,
  behavior: SnackBarBehavior.floating,
  backgroundColor: Colors.transparent,
  content: AwesomeSnackbarContent(
    title: 'Warning!',
    message: 'Something error occurred, please try again !',
    contentType: ContentType.warning,
  ),
);
