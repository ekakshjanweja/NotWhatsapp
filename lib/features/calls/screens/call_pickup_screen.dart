import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/constants/colors.dart';
import 'package:not_whatsapp/constants/font_styles.dart';
import 'package:not_whatsapp/features/calls/controller/call_controller.dart';
import 'package:not_whatsapp/features/calls/screens/call_screen.dart';
import 'package:not_whatsapp/models/call_model.dart';

class CallPickUpScreen extends ConsumerWidget {
  final Widget scaffold;

  const CallPickUpScreen({
    Key? key,
    required this.scaffold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<DocumentSnapshot>(
      stream: ref.watch(callControllerProvider).callStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.data() != null) {
          CallModel call =
              CallModel.fromMap(snapshot.data!.data() as Map<String, dynamic>);

          if (!call.hasDialled) {
            return SafeArea(
              child: Scaffold(
                body: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.1,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Incomming Call',
                        style: FontStyle.h1Bold(context)
                            .copyWith(color: Colors.white),
                      ),

                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),

                      //Caller Image

                      CircleAvatar(
                        backgroundImage: NetworkImage(call.callerPic),
                        radius: MediaQuery.of(context).size.height * 0.15,
                      ),

                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),

                      //Caller Name

                      Text(
                        call.callerName,
                        style:
                            FontStyle.h2(context).copyWith(color: Colors.white),
                      ),

                      //Action Buttons

                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.05,
                          horizontal: MediaQuery.of(context).size.width * 0.2,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //Call Pick

                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CallScreen(
                                        channelId: call.callId,
                                        call: call,
                                        isGroupChat: false,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.call),
                              ),
                            ),
                            //Call End

                            Container(
                              decoration: const BoxDecoration(
                                color: tabColor,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.call_end),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }
        return scaffold;
      },
    );
  }
}
