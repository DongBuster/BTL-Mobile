import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_btl/API/api.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/overlay_loading.dart';
import '../auth/services/auth.dart';
import 'views/modal_bottom_sheet.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  final _api = API();

  @override
  Widget build(BuildContext context) {
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) {
        return const Loading();
      },
    );
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Center(
            child: Text(
              'Profile page',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //--- image user ---
            Center(
                child: Stack(
              children: [
                StreamBuilder(
                  stream: _api.getImageUrlStream(currentUser?.uid ?? ''),
                  builder: (context, snapshot) {
                    // print(snapshot.data);
                    if (snapshot.hasData) {
                      if (snapshot.data == '') {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            'assets/user_default.jpg',
                            width: 90,
                            height: 90,
                          ),
                        );
                      }
                      return ClipOval(
                        child: CachedNetworkImage(
                          width: 90,
                          height: 90,
                          imageUrl: snapshot.data!,
                          errorWidget: (context, url, error) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.asset(
                                'assets/user_default.jpg',
                                width: 90,
                                height: 90,
                              ),
                            );
                          },
                          placeholderFadeInDuration: const Duration(seconds: 1),
                        ),
                      );
                    }
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        'assets/user_default.jpg',
                        width: 90,
                        height: 90,
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => const ChangePictureAvatar(),
                      );
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade200,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.edit,
                          size: 18,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )),
            const SizedBox(height: 10),

            //--- name user ---
            Center(
              child: Text(
                currentUser?.email ?? 'Unknown',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            //--- button logout ---
            Center(
              child: FilledButton.tonal(
                onPressed: () async {
                  overlayState.insert(overlayEntry);
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  await Auth.signOut().then((value) {
                    prefs.setBool('islogin', false);
                    prefs.setString('email', '');
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  });
                  if (context.mounted) {
                    overlayEntry.remove();
                    context.go('/login');
                  }
                },
                style: ButtonStyle(
                  fixedSize: MaterialStatePropertyAll(
                      Size(MediaQuery.of(context).size.width - 140, 45)),
                  backgroundColor: const MaterialStatePropertyAll(
                    Colors.blue,
                  ),
                ),
                child: const Text(
                  'Log out',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ));
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
