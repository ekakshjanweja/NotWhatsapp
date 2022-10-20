import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/common/enums/message_enum.dart';
import 'package:not_whatsapp/common/utils/utils.dart';
import 'package:not_whatsapp/features/chat/controller/chat_controller.dart';

import '../../../constants/colors.dart';

class MessageBox extends ConsumerStatefulWidget {
  final String receiverUserId;
  const MessageBox({
    required this.receiverUserId,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends ConsumerState<MessageBox> {
  bool showSendButton = false;
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  //Send Text Message

  void sendTextMessage() async {
    if (showSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            _messageController.text.trim(),
            widget.receiverUserId,
          );

      setState(() {
        _messageController.text = '';
      });
    }
  }

  //Send File Message

  void sendFileMessage(
    File file,
    MessageEnum messageEnum,
  ) {
    ref.read(chatControllerProvider).sendFileMessage(
          context: context,
          file: file,
          receiverUserId: widget.receiverUserId,
          messageEnum: messageEnum,
        );
  }

  //Select Image

  void selectImage() async {
    File? image = await pickGalleryImage(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  //Select Video

  void selectVideo() async {
    File? video = await pickGalleryVideo(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: TextFormField(
              controller: _messageController,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    showSendButton = true;
                  });
                } else {
                  setState(() {
                    showSendButton = false;
                  });
                }
              },
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
                      onPressed: selectVideo,
                      icon: const Icon(
                        Icons.attach_file_outlined,
                        color: textColor,
                        size: 24,
                      ),
                    ),

                    //Camera

                    IconButton(
                      padding: const EdgeInsets.only(
                        left: 4,
                        top: 4,
                        bottom: 4,
                        right: 10,
                      ),
                      constraints: const BoxConstraints(),
                      onPressed: selectImage,
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

          //Mic or Send

          GestureDetector(
            onTap: sendTextMessage,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(12),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: tabColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                showSendButton ? Icons.send : Icons.mic,
                color: textColor,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
