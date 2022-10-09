import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/common/utils/utils.dart';
import 'package:not_whatsapp/constants/colors.dart';
import 'package:not_whatsapp/constants/font_styles.dart';
import 'package:not_whatsapp/features/authentication/controller/auth_controller.dart';

class UserInfoScreen extends ConsumerStatefulWidget {
  static const String routeName = '/user-info';
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends ConsumerState<UserInfoScreen> {
  //Variables

  final TextEditingController nameController = TextEditingController();
  File? image;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  //Select Profile Picture

  void selectImage(BuildContext context) async {
    image = await pickGalleryImage(context);
    setState(() {});
  }

  //Store User Data

  void storeUserData() async {
    String name = nameController.text.trim();

    print(name);

    if (name.isNotEmpty) {
      ref.read(authControllerProvider).saveUserDataToFirebase(
            context,
            name,
            image,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            //Image Picker

            Stack(
              children: [
                //Current Avatar

                image == null
                    ? CircleAvatar(
                        radius: MediaQuery.of(context).size.height * 0.1,
                        backgroundImage: const NetworkImage(
                          'https://images.unsplash.com/photo-1661765697580-be9f8e39bc06?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=435&q=80',
                        ),
                      )
                    : CircleAvatar(
                        radius: MediaQuery.of(context).size.height * 0.1,
                        backgroundImage: FileImage(
                          image!,
                        ),
                      ),

                //Pick Image Button

                Positioned(
                  bottom: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      selectImage(context);
                    },
                    child: const Icon(
                      Icons.add_a_photo,
                    ),
                  ),
                ),
              ],
            ),

            //TextField For Name Verfication

            Padding(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.width * 0.1,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.80,
                height: MediaQuery.of(context).size.height * 0.08,
                decoration: BoxDecoration(
                  color: appBarColor,
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height * 0.01,
                  ),
                ),
                child: Row(
                  children: [
                    //Name Textfield

                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.02,
                          vertical: MediaQuery.of(context).size.height * 0.015,
                        ),
                        child: TextField(
                          textAlign: TextAlign.start,
                          textAlignVertical: TextAlignVertical.bottom,
                          controller: nameController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            hintText: 'Enter your name.',
                            hintStyle: FontStyle.bodyText(context).copyWith(
                              color: textColor.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width * 0.05,
                    // ),

                    //Username Verified Check Mark

                    IconButton(
                      onPressed: storeUserData,
                      icon: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.01,
                        ),
                        child: const Icon(
                          Icons.done,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
