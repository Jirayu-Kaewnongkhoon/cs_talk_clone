import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final imageUrl = ModalRoute.of(context).settings.arguments;

    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Hero(
        tag: imageUrl,
        child: Image.network(imageUrl),
      ),
    );
  }
}