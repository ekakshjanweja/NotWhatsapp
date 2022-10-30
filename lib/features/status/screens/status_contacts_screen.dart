import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/common/widgets/loader.dart';
import 'package:not_whatsapp/constants/colors.dart';
import 'package:not_whatsapp/constants/font_styles.dart';
import 'package:not_whatsapp/features/status/controller/status_controller.dart';
import 'package:not_whatsapp/models/status_model.dart';

class StatusContactsScreen extends ConsumerWidget {
  const StatusContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<StatusModel>>(
      future: ref.read(statusControllerProvider).getStatus(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            var statusData = snapshot.data![index];

            return Column(
              children: [
                InkWell(
                  onTap: () {},
                  child: ListTile(
                    //Padding

                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 16),

                    //Title

                    title: Text(
                      statusData.username,
                      style: FontStyle.titleStyle(),
                    ),

                    //Leading

                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        statusData.profilePic,
                      ),
                    ),
                  ),
                ),

                //Divider
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Divider(
                    color: dividerColor,
                    indent: 00,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
