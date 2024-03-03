import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ikut_annotation_v2/model/label_image.dart';

class ImageWidget extends StatelessWidget {
  final LabeledImage image;

  const ImageWidget(this.image, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      constraints: const BoxConstraints.expand(),
      child: Image.file(File(image.path), fit: BoxFit.contain),
    );
  }
}
