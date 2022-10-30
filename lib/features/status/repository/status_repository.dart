import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/common/firebase/common_firebase_storage_repository.dart';
import 'package:not_whatsapp/common/utils/utils.dart';
import 'package:not_whatsapp/models/status_model.dart';
import 'package:not_whatsapp/models/user_model.dart';
import 'package:uuid/uuid.dart';

final statusRepositoryProvider = Provider(
  (ref) => StatusRepository(
    firebaseFirestore: FirebaseFirestore.instance,
    firebaseAuth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class StatusRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final ProviderRef ref;

  StatusRepository({
    required this.firebaseFirestore,
    required this.firebaseAuth,
    required this.ref,
  });

  //Upload Status

  Future<void> uploadStatus({
    required String username,
    required String profilePic,
    required String phoneNumber,
    required File statusImage,
    required BuildContext context,
  }) async {
    try {
      //Status Id

      var statusId = const Uuid().v1();

      String uid = firebaseAuth.currentUser!.uid;

      //Store Status In Firebase Storeage

      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            '/status/$statusId$uid',
            statusImage,
          );

      //Get Contacts

      List<Contact> contacts = [];

      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }

      //Create A List Of People Who Can See The Status i.e the contacts

      List<String> uidWhoCanSee = [];

      for (int i = 0; i < contacts.length; i++) {
        var userDataFirebase = await firebaseFirestore
            .collection('users')
            .where(
              'phoneNumber',
              isEqualTo: contacts[i].phones[0].number.replaceAll(
                    ' ',
                    '',
                  ),
            )
            .get();

        if (userDataFirebase.docs.isNotEmpty) {
          var userData = UserModel.fromMap(userDataFirebase.docs[0].data());
          uidWhoCanSee.add(userData.uid);
        }
      }

      //Check if status already exists if yes then add new status

      List<String> statusImageUrls = [];

      var statusSnapshot = await firebaseFirestore
          .collection('status')
          .where(
            'uid',
            isEqualTo: firebaseAuth.currentUser!.uid,
          )
          .where(
            'createdAt',
            isLessThan: DateTime.now().subtract(
              const Duration(hours: 24),
            ),
          )
          .get();

      if (statusSnapshot.docs.isNotEmpty) {
        StatusModel status = StatusModel.fromMap(statusSnapshot.docs[0].data());

        statusImageUrls = status.photoUrl;
        statusImageUrls.add(imageUrl);
        await firebaseFirestore
            .collection('status')
            .doc(statusSnapshot.docs[0].id)
            .update({
          'photoUrl': statusImageUrls,
        });
        return;
      } else {
        statusImageUrls = [imageUrl];
      }

      StatusModel statusModel = StatusModel(
        uid: uid,
        username: username,
        phoneNumber: phoneNumber,
        photoUrl: statusImageUrls,
        createdAt: DateTime.now(),
        profilePic: profilePic,
        statusId: statusId,
        whoCanSee: uidWhoCanSee,
      );

      await firebaseFirestore.collection('status').doc(statusId).set(
            statusModel.toMap(),
          );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  //Get Status

  Future<List<StatusModel>> getStatus(BuildContext context) async {
    List<StatusModel> statusData = [];

    try {
      //Get Contacts

      List<Contact> contacts = [];

      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }

      for (int i = 0; i < contacts.length; i++) {
        var statusSnapshot = await firebaseFirestore
            .collection('status')
            .where(
              'phoneNumber',
              isEqualTo: contacts[i].phones[0].number.replaceAll(
                    ' ',
                    '',
                  ),
            )
            .where(
              'createdAt',
              isGreaterThan: DateTime.now()
                  .subtract(
                    const Duration(hours: 24),
                  )
                  .millisecondsSinceEpoch, //Epoch : Milli seconds since Jan 1 1970
            )
            .get();

        for (var tempData in statusSnapshot.docs) {
          StatusModel tempStatus = StatusModel.fromMap(tempData.data());
          if (tempStatus.whoCanSee.contains(firebaseAuth.currentUser!.uid)) {
            statusData.add(tempStatus);
          }
        }
      }
      print(statusData);
    } catch (e) {
      if (kDebugMode) print(e);
      showSnackBar(context: context, content: e.toString());
    }

    return statusData;
  }
}
