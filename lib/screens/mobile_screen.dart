import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/common/utils/utils.dart';
import 'package:not_whatsapp/constants/colors.dart';
import 'package:not_whatsapp/constants/font_styles.dart';
import 'package:not_whatsapp/features/authentication/controller/auth_controller.dart';
import 'package:not_whatsapp/features/chat/widgets/contacts_list.dart';
import 'package:not_whatsapp/features/group/screens/create_group_screen.dart';
import 'package:not_whatsapp/features/status/screens/confirm_status_screen.dart';
import 'package:not_whatsapp/features/status/screens/status_contacts_screen.dart';

import '../features/select_contacts/screens/select_contacts_screen.dart';

class MobileScreen extends ConsumerStatefulWidget {
  const MobileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends ConsumerState<MobileScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  //Tab Controller
  late TabController tabController;

  //Initialize the binding observer for state of app

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    tabController = TabController(length: 3, vsync: this);
  }

  //Dispose

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  //Check State Of App

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserData(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).setUserData(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appBarColor,
          title: Text(
            'NotWhatsApp',
            style: FontStyle.h1Bold(context),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: textColor,
              ),
            ),
            PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text('New Group'),
                  onTap: () => Future(
                    () => (Navigator.pushNamed(
                      context,
                      CreateGroupScreen.routeName,
                    )),
                  ),
                ),
              ],
            ),
          ],
          bottom: TabBar(
            controller: tabController,
            labelStyle: FontStyle.lableStyle(),
            unselectedLabelStyle: FontStyle.lableStyle(),
            indicatorColor: tabColor,
            indicatorWeight: 4,
            labelColor: tabColor,
            unselectedLabelColor: Colors.grey.shade300,
            tabs: const [
              Tab(text: 'CHATS'),
              Tab(text: 'STATUS'),
              Tab(text: 'CALLS'),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: const [
            ContactsList(),
            StatusContactsScreen(),
            Text('Calls'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (tabController.index == 0) {
              Navigator.pushNamed(
                context,
                SelectContactsScreen.routeName,
              );
            } else {
              File? pickedImage = await pickGalleryImage(context);
              if (pickedImage != null) {
                if (!mounted) return;
                Navigator.pushNamed(
                  context,
                  ConfirmStatusScreen.routeName,
                  arguments: pickedImage,
                );
              }
            }
          },
          child: const Icon(
            Icons.message,
          ),
        ),
      ),
    );
  }
}
