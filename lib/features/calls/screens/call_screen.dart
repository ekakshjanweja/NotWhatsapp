// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/common/widgets/loader.dart';
import 'package:not_whatsapp/constants/agora_config.dart';
import 'package:not_whatsapp/constants/colors.dart';
import 'package:not_whatsapp/features/calls/controller/call_controller.dart';
import 'package:not_whatsapp/features/chat/screens/mobile_chat_screen.dart';

import 'package:not_whatsapp/models/call_model.dart';

class CallScreen extends ConsumerStatefulWidget {
  final String channelId;
  final CallModel call;
  final bool isGroupChat;

  const CallScreen({
    super.key,
    required this.channelId,
    required this.call,
    required this.isGroupChat,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  AgoraClient? client;
  String baseUrl = 'https://not-whatsapp-ekaksh.herokuapp.com/';

  @override
  void initState() {
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: AgoraConfig.appId,
        channelName: widget.channelId,
        tokenUrl: baseUrl,
      ),
    );
    super.initState();
    initAgora();
  }

  //initialize Agora

  void initAgora() async {
    await client!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: client == null
          ? const Loader()
          : SafeArea(
              child: Stack(
                children: [
                  AgoraVideoViewer(client: client!),
                  AgoraVideoButtons(
                    client: client!,
                    disconnectButtonChild: Container(
                      decoration: const BoxDecoration(
                        color: tabColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () async {
                          NavigatorState state = Navigator.of(context);
                          await client!.engine.leaveChannel();

                          ref.read(callControllerProvider).endCall(
                                widget.call.callerId,
                                widget.call.receiverId,
                                context,
                              );
                          state.pushNamed(MobileChatScreen.routeName);
                        },
                        icon: const Icon(
                          Icons.call_end,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
