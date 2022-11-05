import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/common/firebase/common_firebase_storage_repository.dart';
import 'package:not_whatsapp/common/utils/utils.dart';
import 'package:not_whatsapp/models/group.dart' as groupModel;
import 'package:uuid/uuid.dart';

final groupRepositoryProvider = Provider((ref) => GroupRepository(
      firebaseFirestore: FirebaseFirestore.instance,
      firebaseAuth: FirebaseAuth.instance,
      ref: ref,
    ));

class GroupRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final ProviderRef ref;

  GroupRepository({
    required this.firebaseFirestore,
    required this.firebaseAuth,
    required this.ref,
  });

  //Create Group

  void createGroup(BuildContext context, String groupName, File groupImage,
      List<Contact> selectedContacts) async {
    try {
      //List of users in group

      List<String> groupUsers = [];

      for (int i = 0; i < selectedContacts.length; i++) {
        var userCollection = await firebaseFirestore
            .collection('users')
            .where(
              'phoneNumber',
              isEqualTo: selectedContacts[i].phones[0].number.replaceAll(
                    ' ',
                    '',
                  ),
            )
            .get();

        if (userCollection.docs[0].exists) {
          groupUsers.add(userCollection.docs[0].data()['uid']);
        }

        var groupId = const Uuid().v1();

        String groupImageUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase(
              'group/$groupId',
              groupImage,
            );

        groupModel.Group group = groupModel.Group(
          senederId: firebaseAuth.currentUser!.uid,
          groupName: groupName,
          groupId: groupId,
          lastMessage: '',
          groupUsers: [firebaseAuth.currentUser!.uid, ...groupUsers],
          groupImage: groupImageUrl,
        );

        await firebaseFirestore
            .collection('groups')
            .doc(groupId)
            .set(group.toMap());
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
