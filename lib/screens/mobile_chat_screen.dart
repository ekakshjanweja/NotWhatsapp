// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/common/widgets/loader.dart';

import 'package:not_whatsapp/constants/colors.dart';
import 'package:not_whatsapp/constants/font_styles.dart';
import 'package:not_whatsapp/constants/info.dart';
import 'package:not_whatsapp/features/authentication/controller/auth_controller.dart';
import 'package:not_whatsapp/models/user_model.dart';
import 'package:not_whatsapp/widgets/Chat_list.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/mobile-chat-screen';

  final String name;
  final String uid;

  const MobileChatScreen({
    Key? key,
    required this.name,
    required this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String appBarName =
        name.length >= 10 ? '${name.substring(0, 10)}....' : name;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                info[4]['profilePic'].toString(),
              ),
              radius: 20,
            ),
            const SizedBox(
              width: 16,
            ),
            StreamBuilder<UserModel>(
                stream: ref.read(authControllerProvider).userDataById(uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Loader();
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appBarName,
                          style: FontStyle.titleStyle(),
                        ),
                        Text(
                          snapshot.data!.isOnline ? 'online' : 'offline',
                          style: FontStyle.subTitleStyle(),
                        ),
                      ],
                    );
                  }
                }),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          //Chats List

          const Expanded(
            child: ChatList(),
          ),

          //Message Box

          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            padding: const EdgeInsets.only(
              top: 12,
              bottom: 12,
              left: 10,
            ),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: dividerColor,
                ),
              ),
              color: appBarColor,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                      contentPadding: const EdgeInsets.only(
                        top: 8,
                        bottom: 8,
                        left: 16,
                      ),

                      //Emoji

                      prefixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.emoji_emotions_outlined,
                          color: textColor,
                          size: 24,
                        ),
                      ),

                      suffixIcon: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //Files

                          IconButton(
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                            onPressed: () {},
                            icon: const Icon(
                              Icons.attach_file_outlined,
                              color: textColor,
                              size: 24,
                            ),
                          ),

                          //Mic

                          IconButton(
                            padding: const EdgeInsets.only(
                              left: 4,
                              top: 4,
                              bottom: 4,
                              right: 10,
                            ),
                            constraints: const BoxConstraints(),
                            onPressed: () {},
                            icon: const Icon(
                              Icons.camera_alt,
                              color: textColor,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                //Send

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  padding: const EdgeInsets.all(12),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: tabColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.mic,
                    color: textColor,
                    size: 24,
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
