import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_btl/API/api.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../common/overlay_loading.dart';
import '../view_model/profile_page_view_model.dart';

class ChangePictureAvatar extends StatefulWidget {
  const ChangePictureAvatar({super.key});

  @override
  State<ChangePictureAvatar> createState() => _ChangePictureAvatarState();
}

class _ChangePictureAvatarState extends State<ChangePictureAvatar> {
  User? currentUser = FirebaseAuth.instance.currentUser!;
  final _api = API();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) {
        return const Loading();
      },
    );
    return Consumer<ProfilePageViewModel>(
      builder: (context, viewModel, child) {
        File? imageFilePick = viewModel.imagePicker;
        return Container(
          padding: const EdgeInsets.all(15),
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              imageFilePick != null
                  ? ClipOval(
                      child: Image.file(
                        imageFilePick,
                        cacheHeight: 90,
                        cacheWidth: 90,
                      ),
                    )
                  : FutureBuilder<String>(
                      future: _api.getUrlImageFuture(currentUser?.uid ?? ''),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
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
                                    width: 100,
                                    height: 100,
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
              const Gap(30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      viewModel.pickImage(ImageSource.camera).then(
                            (value) => setState(() {
                              imageFilePick = value;
                            }),
                          );
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Colors.blue..withOpacity(0.8))),
                    child: const Text(
                      'Pick from camera',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Gap(15),
                  TextButton(
                    onPressed: () {
                      viewModel.pickImage(ImageSource.gallery).then(
                            (value) => setState(() {
                              imageFilePick = value;
                            }),
                          );
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Colors.blue.withOpacity(0.8))),
                    child: const Text(
                      'Pick from gallery',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () async {
                  if (imageFilePick == null) {
                    context.pop();
                  } else {
                    overlayState.insert(overlayEntry);
                    await viewModel.pushUserImage().whenComplete(() {
                      imageFilePick = null;
                      overlayEntry.remove();
                      context.pop();
                    });
                  }
                },
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.green)),
                child: const Text(
                  'Done',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
