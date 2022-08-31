import 'package:flutter/material.dart';
import 'package:not_whatsapp/constants/colors.dart';
import 'package:not_whatsapp/constants/info.dart';

class WebProfileBar extends StatelessWidget {
  const WebProfileBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.077,
      width: MediaQuery.of(context).size.width * 0.3,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(color: dividerColor),
        ),
        color: webAppBarColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Avatar

          CircleAvatar(
            backgroundImage: NetworkImage(
              info[4]['profilePic'].toString(),
            ),
            radius: 20,
          ),

          //Icons

          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.comment_rounded,
                  color: textColor,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: textColor,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
