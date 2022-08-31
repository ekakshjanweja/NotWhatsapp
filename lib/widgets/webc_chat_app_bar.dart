import 'package:flutter/material.dart';
import 'package:not_whatsapp/constants/colors.dart';
import 'package:not_whatsapp/constants/font_styles.dart';
import 'package:not_whatsapp/constants/info.dart';

class WebChatAppBar extends StatelessWidget {
  const WebChatAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height * 0.077,
      padding: const EdgeInsets.all(10),
      color: webAppBarColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Row 1

          Row(
            children: [
              //Image

              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  info[4]['profilePic'].toString(),
                ),
              ),

              //Name

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.01,
              ),

              Text(
                info[0]['name'].toString(),
                style: FontStyle.h2(context),
              )
            ],
          ),

          //Row 2

          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  color: textColor.withOpacity(0.5),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.more_vert,
                  color: textColor.withOpacity(0.5),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
