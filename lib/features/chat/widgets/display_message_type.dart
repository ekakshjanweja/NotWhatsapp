import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:not_whatsapp/common/enums/message_enum.dart';
import 'package:not_whatsapp/constants/font_styles.dart';
import 'package:not_whatsapp/features/chat/widgets/video_player_item.dart';

class DisplayMessageType extends StatelessWidget {
  final String message;
  final MessageEnum messageEnum;

  const DisplayMessageType({
    Key? key,
    required this.message,
    required this.messageEnum,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return messageEnum == MessageEnum.text
        ? Text(
            message,
            style: FontStyle.messageText(),
          )
        : messageEnum == MessageEnum.video
            ? VideoPlayerItem(videoUrl: message)
            : CachedNetworkImage(
                imageUrl: message,
              );
  }
}
