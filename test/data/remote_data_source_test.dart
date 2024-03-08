import 'package:flutter_test/flutter_test.dart';
import 'package:ikut_annotation_v2/data/remote_data_source.dart';
import 'package:ikut_annotation_v2/model/labeled_image.dart';

import '../util/helper.dart';

void main() {
  final remoteDataSource = RemoteDataSource();

  tw("load", () {
    tt("AnnotationTask instance is returned", () async {
      final task = await remoteDataSource
          .load("https://ikut-annotation-sample.web.app/task.yaml");
      expect(["takoyaki", "sushi", "gyoza", "other"], task.labels);
      expect(300, task.images.length);
      expect(
          const LabeledImage(
              id: 0,
              url: "https://ikut-annotation-sample.web.app/image/1002013.jpg",
              label: "takoyaki"),
          task.images[0]);
      expect(
          const LabeledImage(
              id: 0,
              url: "https://ikut-annotation-sample.web.app/image/1399892.jpg",
              label: "takoyaki"),
          task.images[299]);
    });
  });
}
