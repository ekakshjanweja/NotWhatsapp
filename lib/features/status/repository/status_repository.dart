import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/common/utils/utils.dart';

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
    try {} catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
