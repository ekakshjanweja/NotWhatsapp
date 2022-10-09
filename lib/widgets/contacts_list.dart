import 'package:flutter/material.dart';
import 'package:not_whatsapp/constants/colors.dart';
import 'package:not_whatsapp/constants/font_styles.dart';
import 'package:not_whatsapp/constants/info.dart';
import 'package:not_whatsapp/features/chat/screens/mobile_chat_screen.dart';

class ContactsList extends StatelessWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double currentWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: info.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              if (currentWidth < 900) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MobileChatScreen(
                      name: 'Tanishi Janweja',
                      uid: '123',
                    ),
                  ),
                );
              }
            },
            child: Column(
              children: [
                ListTile(
                  //Padding

                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 16),

                  //Title

                  title: Text(
                    info[index]['name'].toString(),
                    style: FontStyle.titleStyle(),
                  ),

                  //Subtitle

                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      info[index]['message'].toString(),
                      style: FontStyle.subTitleStyle(),
                    ),
                  ),

                  //Leading

                  leading: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      info[index]['profilePic'].toString(),
                    ),
                  ),

                  //Trailling

                  trailing: Text(
                    info[index]['time'].toString(),
                    style: FontStyle.bodyText(context),
                  ),
                ),

                //Divider

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Divider(
                    color: dividerColor,
                    indent: 80,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
