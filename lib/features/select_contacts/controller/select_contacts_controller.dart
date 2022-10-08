import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/features/select_contacts/firebase/select_contact_repository.dart';

final getContactsProvider = FutureProvider((ref) {
  final selectContactsRepository = ref.watch(selectContactsRepositoryProvider);
  return selectContactsRepository.getContacts();
});

final selectContactControllerProvider = Provider((ref) {
  final selectContactsRepository = ref.watch(selectContactsRepositoryProvider);
  return SelectContactController(
    ref: ref,
    selectContactsRepository: selectContactsRepository,
  );
});

class SelectContactController {
  final ProviderRef ref;
  final SelectContactsRepository selectContactsRepository;

  SelectContactController({
    required this.ref,
    required this.selectContactsRepository,
  });

  //Select Contact

  void selectContact(Contact selectedContact, BuildContext context) {
    selectContactsRepository.selectContact(selectedContact, context);
  }
}
