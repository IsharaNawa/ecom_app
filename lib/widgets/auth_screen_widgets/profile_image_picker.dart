import 'package:flutter/material.dart';

class ProfileImagePicker extends StatelessWidget {
  const ProfileImagePicker({super.key, required this.borderColor});

  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: 1.0,
        ),
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Image.network(
          "https://cdn.pixabay.com/photo/2013/07/13/12/07/avatar-159236_640.png",
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
