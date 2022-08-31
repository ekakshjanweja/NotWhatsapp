import 'package:flutter/material.dart';
import 'package:not_whatsapp/constants/colors.dart';
import 'package:not_whatsapp/constants/font_styles.dart';
import 'package:not_whatsapp/constants/info.dart';
import 'package:not_whatsapp/widgets/Chat_list.dart';

class MobileChatScreen extends StatelessWidget {
  const MobileChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Name

            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    info[4]['profilePic'].toString(),
                  ),
                  radius: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  info[0]['name'].toString(),
                  style: FontStyle.titleStyle(),
                ),
              ],
            ),
            //Icons

            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.call),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.video_call),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.more_vert),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          //Chats List

          const Expanded(
            child: ChatList(),
          ),

          //Message Box

          Container(
            height: MediaQuery.of(context).size.height * 0.08,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: dividerColor,
                ),
              ),
              color: appBarColor,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Emoji

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.emoji_emotions_outlined,
                      color: textColor,
                    ),
                  ),

                  //Files

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.attach_file_outlined,
                      color: textColor,
                    ),
                  ),

                  //Text Field
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        fillColor: searchBarColor,
                        filled: true,
                        hintText: 'Type a message',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                      ),
                    ),
                  ),

                  //Mic

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.mic,
                      color: textColor,
                    ),
                  ),

                  //Send

                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: tabColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.send,
                        color: textColor,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
