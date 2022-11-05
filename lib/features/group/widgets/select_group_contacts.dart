import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/common/widgets/error_screen.dart';
import 'package:not_whatsapp/common/widgets/loader.dart';
import 'package:not_whatsapp/constants/colors.dart';
import 'package:not_whatsapp/constants/font_styles.dart';
import 'package:not_whatsapp/features/select_contacts/controller/select_contacts_controller.dart';

final selectedGroupContacts = StateProvider<List<Contact>>((ref) => []);

class SelectGroupContacts extends ConsumerStatefulWidget {
  const SelectGroupContacts({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectGroupContactsState();
}

class _SelectGroupContactsState extends ConsumerState<SelectGroupContacts> {
  List<int> selectedContactsIndex = [];

  //Select Contact

  void selectContact(int index, Contact contact) {
    if (selectedContactsIndex.contains(index)) {
      selectedContactsIndex.removeAt(index);
    } else {
      selectedContactsIndex.add(index);
    }

    //Updating Riverpod Provider State

    ref
        .read(selectedGroupContacts.state)
        .update((state) => [...state, contact]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getContactsProvider).when(
          data: (contactList) => Expanded(
            child: ListView.builder(
                itemCount: contactList.length,
                itemBuilder: (context, index) {
                  final contact = contactList[index];

                  return InkWell(
                    onTap: () => selectContact(index, contact),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        color: selectedContactsIndex.contains(index)
                            ? tabColor.withOpacity(0.2)
                            : Colors.transparent,
                        child: ListTile(
                          title: Text(
                            contact.displayName,
                            style: FontStyle.titleStyle(),
                          ),
                          leading: selectedContactsIndex.contains(index)
                              ? const Icon(
                                  Icons.done,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                    ),
                  );
                }),
          ),
          error: (error, stackTrace) => ErrorScreen(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
