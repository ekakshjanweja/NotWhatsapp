import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/common/widgets/loader.dart';
import 'package:not_whatsapp/constants/colors.dart';
import 'package:not_whatsapp/constants/font_styles.dart';
import 'package:not_whatsapp/features/authentication/controller/auth_controller.dart';
import 'package:not_whatsapp/features/chat/widgets/message_box.dart';
import 'package:not_whatsapp/models/user_model.dart';
import 'package:not_whatsapp/features/chat/widgets/chat_list.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/mobile-chat-screen';

  final String name;
  final String uid;
  final bool isGroupChat;
  final String displayImage;

  const MobileChatScreen({
    Key? key,
    required this.name,
    required this.uid,
    required this.isGroupChat,
    required this.displayImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String appBarName =
        name.length >= 10 ? '${name.substring(0, 10)}....' : name;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        titleSpacing: 0,
        title: isGroupChat
            ? Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      displayImage,
                    ),
                    radius: 20,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(name),
                ],
              )
            : Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      displayImage,
                    ),
                    radius: 20,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  StreamBuilder<UserModel>(
                      stream:
                          ref.read(authControllerProvider).userDataById(uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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

          Expanded(
            child: ChatList(
              receiverUserId: uid,
              isGroupChat: isGroupChat,
            ),
          ),

          //Message Box

          MessageBox(
            receiverUserId: uid,
            isGroupChat: isGroupChat,
          ),
        ],
      ),
    );
  }
}
