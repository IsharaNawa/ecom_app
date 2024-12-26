import 'dart:io';

import 'package:ecom_app/services/app_functions.dart';
import 'package:ecom_app/services/icon_manager.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImagePicker extends StatefulWidget {
  const ProfileImagePicker({super.key, required this.borderColor});

  final Color borderColor;

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  File? pickedImage;
  final ImagePicker imagePicker = ImagePicker();

  Future<void> getImage(ImageSource imageSource) async {
    XFile? pickedImageXFile = await imagePicker.pickImage(source: imageSource);

    if (pickedImageXFile == null) {
      return;
    }

    setState(() {
      pickedImage = File(pickedImageXFile.path);
    });
  }

  Future<void> triggerImagePickDialogBox() async {
    await AppFunctions.showErrorOrWarningOrImagePickerDialog(
      context: context,
      isWarning: true,
      mainTitle: "Select Your Image Source",
      icon: Icon(IconManager.showImagePickerDialogBoxIcon),
      action1Text: "Camera",
      action2Text: "Gallery",
      action1Func: () async {
        await getImage(ImageSource.camera);
        Navigator.of(context).pop();
      },
      action2Func: () async {
        await getImage(ImageSource.gallery);
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> triggerImageDeletionConfirmationDialogBox() async {
    await AppFunctions.showErrorOrWarningOrImagePickerDialog(
      context: context,
      isWarning: true,
      mainTitle: "Do you want to delete the Image?",
      icon: Icon(IconManager.deletePickedImageIcon),
      action1Text: "No",
      action2Text: "Yes",
      action1Func: () async {
        Navigator.of(context).pop();
      },
      action2Func: () async {
        setState(() {
          pickedImage = null;
        });
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget imageIconContent = InkWell(
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Icon(
            IconManager.showImagePickerDialogBoxIcon,
          ),
        ),
      ),
      onTap: () {
        triggerImagePickDialogBox();
      },
    );

    if (pickedImage != null) {
      imageIconContent = InkWell(
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Icon(
              IconManager.deletePickedImageIcon,
            ),
          ),
        ),
        onTap: () {
          triggerImageDeletionConfirmationDialogBox();
        },
      );
    }

    return GestureDetector(
      onTap: () async {
        triggerImagePickDialogBox();
      },
      child: Stack(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.borderColor,
                width: 1.0,
              ),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: pickedImage == null
                  ? FancyShimmerImage(
                      imageUrl:
                          "https://cdn.pixabay.com/photo/2013/07/13/12/07/avatar-159236_640.png",
                      height: 100,
                      width: 100,
                      boxFit: BoxFit.cover,
                    )
                  : Image.file(
                      pickedImage!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: imageIconContent,
          ),
        ],
      ),
    );
  }
}
