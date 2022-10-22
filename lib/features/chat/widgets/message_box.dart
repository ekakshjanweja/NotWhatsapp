import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:giphy_get/giphy_get.dart';
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
  bool isShowEmojiContainer = false;
  final TextEditingController _messageController = TextEditingController();
  FocusNode focusNode = FocusNode();

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

  // //Select GIF

  void selectGIF() async {
    GiphyGif? gif = await pickGIF(context);
    if (!mounted) return; // Why was this used??
    if (gif != null) {
      ref.read(chatControllerProvider).sendGIFMessage(
            context,
            gif.url.toString(),
            widget.receiverUserId,
          );
    }
  }

  //Hide Emoji Container

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  //Show Emoji Container

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  //Toggle Keyboard

  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  //Show Keyboard

  void showKeyboard() => focusNode.requestFocus();

  //Hide Keyboard

  void hideKeyboard() => focusNode.unfocus();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isShowEmojiContainer
          ? MediaQuery.of(context).size.height * 0.51
          : MediaQuery.of(context).size.height * 0.104,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: dividerColor,
          ),
        ),
        color: appBarColor,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 12,
              bottom: 10,
              top: 12,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Text Field

                Expanded(
                  child: TextFormField(
                    controller: _messageController,
                    focusNode: focusNode,
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
                      prefixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //Emoji

                          IconButton(
                            padding: const EdgeInsets.only(left: 10),
                            constraints: const BoxConstraints(),
                            onPressed: toggleEmojiKeyboardContainer,
                            icon: const Icon(
                              Icons.emoji_emotions_outlined,
                              color: textColor,
                              size: 24,
                            ),
                          ),

                          //GIF

                          IconButton(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            constraints: const BoxConstraints(),
                            onPressed: selectGIF,
                            icon: const Icon(
                              Icons.gif,
                              color: textColor,
                              size: 24,
                            ),
                          ),
                        ],
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
          ),

          //Emoji Picker

          isShowEmojiContainer
              ? SizedBox(
                  height: 310,
                  child: EmojiPicker(
                    onEmojiSelected: ((catagory, emoji) {
                      setState(() {
                        _messageController.text =
                            _messageController.text + emoji.emoji;
                      });
                      if (!showSendButton) {
                        setState(() {
                          showSendButton = true;
                        });
                      }
                    }),
                  ),
                )
              : const SizedBox(
                  height: 0,
                ),
        ],
      ),
    );
  }
}
