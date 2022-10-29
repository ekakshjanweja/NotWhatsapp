import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
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
    bool isPlaying = false;

    final AudioPlayer audioPlayer = AudioPlayer();

    return Container(
      child: messageEnum == MessageEnum.text
          ? Text(
              message,
              style: FontStyle.messageText(),
            )
          : messageEnum == MessageEnum.video
              ? VideoPlayerItem(videoUrl: message)
              : messageEnum == MessageEnum.gif
                  ? CachedNetworkImage(
                      imageUrl: message,
                    )
                  : messageEnum == MessageEnum.audio
                      ? StatefulBuilder(builder: (context, setstate) {
                          return IconButton(
                            constraints: const BoxConstraints(minWidth: 100),
                            onPressed: () async {
                              if (isPlaying) {
                                await audioPlayer.pause();
                              } else {
                                await audioPlayer.play(UrlSource(message));
                              }
                              setstate(() {
                                isPlaying = !isPlaying;
                              });
                            },
                            icon: Icon(isPlaying
                                ? Icons.pause_circle
                                : Icons.play_circle),
                          );
                        })
                      : CachedNetworkImage(
                          imageUrl: message,
                        ),
    );
  }
}
