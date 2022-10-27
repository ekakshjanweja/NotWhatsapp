// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:not_whatsapp/common/enums/message_enum.dart';
import 'package:not_whatsapp/constants/colors.dart';
import 'package:not_whatsapp/constants/font_styles.dart';
import 'package:not_whatsapp/features/chat/widgets/display_message_type.dart';
import 'package:swipe_to/swipe_to.dart';

class UserMessageCard extends StatelessWidget {
  final String message;
  final String time;
  final MessageEnum messageEnum;
  final VoidCallback onLeftSwipe;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;
  const UserMessageCard({
    Key? key,
    required this.message,
    required this.time,
    required this.messageEnum,
    required this.onLeftSwipe,
    required this.repliedText,
    required this.username,
    required this.repliedMessageType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;
    return SwipeTo(
      onLeftSwipe: onLeftSwipe,
      child: Align(
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
                      crossAxisAlignment: isReplying
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.center,
                      children: [
                        if (isReplying) ...{
                          Container(
                            decoration: BoxDecoration(
                                color: backgroundColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(5)),
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 8,
                            ),
                            child: Text(
                              username,
                              style: FontStyle.bodyText(context).copyWith(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: backgroundColor.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(5)),
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                            child: DisplayMessageType(
                              message: repliedText,
                              messageEnum: repliedMessageType,
                            ),
                          )
                        },
                        const SizedBox(
                          height: 8,
                        ),
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
      ),
    );
  }
}
