import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final image = ModalRoute.of(context).settings.arguments;

    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Hero(
        tag: 'photo',
        child: image,
      ),
    );
  }
}