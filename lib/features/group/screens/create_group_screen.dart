import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/common/utils/utils.dart';
import 'package:not_whatsapp/constants/colors.dart';
import 'package:not_whatsapp/constants/font_styles.dart';
import 'package:not_whatsapp/features/group/controller/group_controller.dart';
import 'package:not_whatsapp/features/group/widgets/select_group_contacts.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  static const String routeName = '/create-group';
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  final TextEditingController groupNameController = TextEditingController();
  File? image;

  //Select Image

  void selectImage() async {
    image = await pickGalleryImage(context);
    setState(() {});
  }

  //Created Group

  void createGroup() {
    if (groupNameController.text.trim().isNotEmpty && image != null) {
      ref.read(groupControllerProvider).createGroup(
            context,
            groupNameController.text.trim(),
            image!,
            ref.read(
              selectedGroupContacts,
            ),
          );
    }
  }

  @override
  void dispose() {
    super.dispose();
    groupNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Greate Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Image

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
                      selectImage();
                    },
                    child: const Icon(
                      Icons.add_a_photo,
                    ),
                  ),
                ),
              ],
            ),

            //Group Name

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.15,
                vertical: MediaQuery.of(context).size.height * 0.02,
              ),
              child: TextField(
                controller: groupNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter Group Name',
                ),
              ),
            ),

            //Select Contacts

            Text(
              'Select Contacts',
              style: FontStyle.h2(context).copyWith(color: tabColor),
            ),

            const SizedBox(
              height: 10,
            ),

            //Select Group Contacts

            SelectGroupContacts(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: tabColor,
        child: const Icon(Icons.done),
      ),
    );
  }
}
