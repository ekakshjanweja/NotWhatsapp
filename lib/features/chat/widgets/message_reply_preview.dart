import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/common/providers/message_reply_provider.dart';
import 'package:not_whatsapp/constants/font_styles.dart';

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
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          //Reply Message

          Expanded(
            child: Text(
              messageReply!.isMe ? 'Me' : 'Opposite',
              style: FontStyle.bodyText(context).copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          //Close Icon

          GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.close,
              size: 16,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          //Reply

          Text(messageReply.message),
        ],
      ),
    );
  }
}
