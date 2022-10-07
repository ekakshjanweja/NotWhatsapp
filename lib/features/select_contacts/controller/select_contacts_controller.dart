import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/features/select_contacts/firebase/select_contact_repository.dart';

final getContactsProvider = FutureProvider((ref) {
  final selectContactsRepository = ref.watch(selectContactsRepositoryProvider);
  return selectContactsRepository.getContacts();
});
