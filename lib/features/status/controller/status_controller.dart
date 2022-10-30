import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/features/authentication/controller/auth_controller.dart';
import 'package:not_whatsapp/features/status/repository/status_repository.dart';
import 'package:not_whatsapp/models/status_model.dart';

final statusControllerProvider = Provider(
  (ref) {
    final statusRepository = ref.read(statusRepositoryProvider);

    return StatusController(
      statusRepository: statusRepository,
      ref: ref,
    );
  },
);

class StatusController {
  final StatusRepository statusRepository;
  final ProviderRef ref;

  StatusController({
    required this.statusRepository,
    required this.ref,
  });

  //Add Status

  void addStatus(File file, BuildContext context) {
    ref.watch(userDataAuthProvider).whenData((value) {
      statusRepository.uploadStatus(
        username: value!.name,
        profilePic: value.profilePic,
        phoneNumber: value.phoneNumber,
        statusImage: file,
        context: context,
      );
    });
  }

  //Get Status

  Future<List<StatusModel>> getStatus(BuildContext context) async {
    List<StatusModel> status = await statusRepository.getStatus(context);
    return status;
  }
}
