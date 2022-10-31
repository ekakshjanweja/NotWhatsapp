import 'package:flutter/material.dart';
import 'package:not_whatsapp/common/widgets/loader.dart';
import 'package:not_whatsapp/models/status_model.dart';
import 'package:story_view/story_view.dart';

class StatusScreen extends StatefulWidget {
  static const String routeName = '/status-screeen';
  final StatusModel status;
  const StatusScreen({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  //Story Controller

  StoryController storyController = StoryController();

  //Story Items List

  List<StoryItem> storyItems = [];

  @override
  void initState() {
    super.initState();
    initializeStoryPageItems();
  }

  void initializeStoryPageItems() {
    for (int i = 0; i < widget.status.photoUrl.length; i++) {
      storyItems.add(
        StoryItem.pageImage(
          url: widget.status.photoUrl[i],
          controller: storyController,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: storyItems.isEmpty
          ? const Loader()
          : StoryView(
              storyItems: storyItems,
              controller: storyController,
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.pop(context);
                }
              },
            ),
    );
  }
}
