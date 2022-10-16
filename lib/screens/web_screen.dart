import 'package:flutter/material.dart';
import 'package:not_whatsapp/constants/colors.dart';
import 'package:not_whatsapp/features/chat/widgets/chat_list.dart';
import 'package:not_whatsapp/features/chat/widgets/contacts_list.dart';
import 'package:not_whatsapp/widgets/web_profile_bar.dart';
import 'package:not_whatsapp/widgets/web_search_bar.dart';
import 'package:not_whatsapp/widgets/webc_chat_app_bar.dart';

class WebScreen extends StatelessWidget {
  const WebScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: const [
                  //Web Profile Bar
                  WebProfileBar(),

                  //Web Search Bar

                  WebSearchBar(),

                  //Contacts List

                  ContactsList(),
                ],
              ),
            ),
          ),

          //Web Screen

          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.cover),
            ),
            child: Column(
              children: [
                //Chat App Bar

                WebChatAppBar(),

                //Chat List

                Expanded(
                  child: ChatList(receiverUserId: 'empty user id'),
                ),

                //Message Box

                Container(
                  height: MediaQuery.of(context).size.height * 0.09,
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
          ),
        ],
      ),
    );
  }
}
