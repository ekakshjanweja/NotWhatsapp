import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:not_whatsapp/common/widgets/loader.dart';
import 'package:not_whatsapp/constants/colors.dart';
import 'package:not_whatsapp/constants/font_styles.dart';
import 'package:not_whatsapp/constants/info.dart';
import 'package:not_whatsapp/features/chat/controller/chat_controller.dart';
import 'package:not_whatsapp/features/chat/screens/mobile_chat_screen.dart';
import 'package:not_whatsapp/models/chat_contact.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double currentWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: StreamBuilder<List<ChatContact>>(
          stream: ref.watch(chatControllerProvider).chatStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loader();
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var chatStreamTileData = snapshot.data![index];
                return InkWell(
                  onTap: () {
                    if (currentWidth < 900) {
                      Navigator.pushNamed(
                        context,
                        MobileChatScreen.routeName,
                        arguments: {
                          'name': chatStreamTileData.name,
                          'uid': chatStreamTileData.contactId,
                        },
                      );
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ListTile(
                        //Padding

                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 16),

                        //Title

                        title: Text(
                          chatStreamTileData.name,
                          style: FontStyle.titleStyle(),
                        ),

                        //Subtitle

                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            chatStreamTileData.lastMessage,
                            style: FontStyle.subTitleStyle(),
                          ),
                        ),

                        //Leading

                        leading: CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                            chatStreamTileData.profilePic,
                          ),
                        ),

                        //Trailling

                        trailing: Text(
                          DateFormat.Hm().format(chatStreamTileData.timeSent),
                          style: FontStyle.bodyText(context),
                        ),
                      ),

                      //Divider

                      const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        child: Divider(
                          color: dividerColor,
                          indent: 00,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
    );
  }
}
