import 'dart:io';
import 'package:flutter/material.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:image_picker/image_picker.dart';

//Snack Bar

void showSnackBar({
  required BuildContext context,
  required String content,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

//Pick Image

Future<File?> pickGalleryImage(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBar(
      context: context,
      content: e.toString(),
    );
  }

  return image;
}

//Pick Video

Future<File?> pickGalleryVideo(BuildContext context) async {
  File? video;
  try {
    final pickedVideo =
        await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      video = File(pickedVideo.path);
    }
  } catch (e) {
    showSnackBar(
      context: context,
      content: e.toString(),
    );
  }

  return video;
}

//Pick GIF

Future<GiphyGif?> pickGIF(BuildContext context) async {
  //E7ngZHOcb7ELb3AoFUgL4xLEAGZiFCjV

  GiphyGif? gif;
  try {
    gif = await GiphyGet.getGif(
      context: context,
      lang: GiphyLanguage.english,
      apiKey: 'E7ngZHOcb7ELb3AoFUgL4xLEAGZiFCjV',
    );
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  return gif;
}
