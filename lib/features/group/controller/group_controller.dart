import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/features/group/repository/group_repository.dart';

final groupControllerProvider = Provider((ref) {
  final GroupRepository groupRepository = ref.read(groupRepositoryProvider);
  return GroupController(groupRepository: groupRepository, ref: ref);
});

class GroupController {
  final GroupRepository groupRepository;
  final ProviderRef ref;

  GroupController({
    required this.groupRepository,
    required this.ref,
  });

  //Create Group

  void createGroup(
    BuildContext context,
    String groupName,
    File groupImage,
    List<Contact> selectedContacts,
  ) {
    groupRepository.createGroup(
      context,
      groupName,
      groupImage,
      selectedContacts,
    );
  }
}
