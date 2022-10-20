// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:not_whatsapp/common/enums/message_enum.dart';
import 'package:not_whatsapp/constants/colors.dart';
import 'package:not_whatsapp/features/chat/widgets/display_message_type.dart';

class UserMessageCard extends StatelessWidget {
  final String message;
  final String time;
  final MessageEnum messageEnum;
  const UserMessageCard({
    Key? key,
    required this.message,
    required this.time,
    required this.messageEnum,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: messageColor,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 30,
                  ),
                  child: Column(
                    children: [
                      DisplayMessageType(
                        message: message,
                        messageEnum: messageEnum,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Row(
                    children: [
                      Text(time),
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(
                        Icons.done_all,
                        size: 20,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
