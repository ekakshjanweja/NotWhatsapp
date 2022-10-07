import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectContactsRepositoryProvider = Provider(
  (ref) => SelectContactsRepository(
    firebaseFirestore: FirebaseFirestore.instance,
  ),
);

class SelectContactsRepository {
  final FirebaseFirestore firebaseFirestore;

  SelectContactsRepository({
    required this.firebaseFirestore,
  });

  Future<List<Contact>> getContacts() async {
    //Contacts List

    List<Contact> contacts = [];

    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(
        e.toString(),
      );
    }

    return contacts;
  }
}
