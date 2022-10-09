import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/common/utils/utils.dart';
import 'package:not_whatsapp/models/user_model.dart';
import 'package:not_whatsapp/screens/mobile_chat_screen.dart';

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

  //Get Contacts

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

  //Select Contact

  void selectContact(Contact selectedContact, BuildContext context) async {
    NavigatorState state = Navigator.of(context);
    try {
      var userCollection = await firebaseFirestore.collection('users').get();
      bool isFound = false;

      for (var doc in userCollection.docs) {
        var userData = UserModel.fromMap(
          doc.data(),
        );
        String selectedPhoneNumber =
            selectedContact.phones[0].number.replaceAll(
          ' ',
          '',
        );
        if (selectedPhoneNumber == userData.phoneNumber) {
          isFound = true;
          print(selectedPhoneNumber);

          //Navigator

          state.pushNamed(
            MobileChatScreen.routeName,
            arguments: {
              'name': userData.name,
              'uid': userData.uid,
            },
          );
        }
        if (!isFound) {
          showSnackBar(
            context: context,
            content: 'This number does not exist on this app.',
          );
        }
      }
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }
}
