import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/common/providers/message_reply_provider.dart';
import 'package:not_whatsapp/constants/colors.dart';
import 'package:not_whatsapp/constants/font_styles.dart';
import 'package:not_whatsapp/features/chat/widgets/display_message_type.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({super.key});

  void cancelReply(WidgetRef ref) {
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Message For Reply

    final messageReply = ref.watch(messageReplyProvider);

    return Container(
      color: appBarColor.withOpacity(0.5),
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Reply Message

          Text(
            messageReply!.isMe ? 'Me' : 'Opposite',
            style: FontStyle.bodyText(context).copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(
            width: 16,
          ),

          //Reply

          Expanded(
            child: DisplayMessageType(
              message: messageReply.message,
              messageEnum: messageReply.messageEnum,
            ),
          ),

          const SizedBox(
            width: 16,
          ),

          //Close Icon

          GestureDetector(
            onTap: () => cancelReply(ref),
            child: const Icon(
              Icons.close,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
