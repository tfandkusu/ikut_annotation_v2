import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikut_annotation_v2/data/local_data_source.dart';
import 'package:ikut_annotation_v2/model/annotation_task.dart';
import 'package:ikut_annotation_v2/model/labeled_image.dart';

import '../util/helper.dart';

void main() {
  late LocalDataSource dataSource;
  setUp(() {
    dataSource = LocalDataSource.test(NativeDatabase.memory());
  });
  tw("saveAnnotationTask", () {
    tt("labels and images can be watched", () async {
      final labels = ["takoyaki", "sushi", "gyoza", "other"];
      final images = [
        const LabeledImage(id: 1, url: "img/01.png", label: "sushi"),
        const LabeledImage(id: 2, url: "img/02.png", label: "takoyaki"),
        const LabeledImage(id: 3, url: "img/03.png", label: "gyoza"),
        const LabeledImage(id: 4, url: "img/04.png", label: "sushi"),
      ];
      final annotationTask = AnnotationTask(labels: labels, images: images);
      dataSource.saveAnnotationTask(annotationTask);
      expect(labels, await dataSource.watchLabels().first);
      expect(images, await dataSource.watchImages().first);
    });
  });

  tw("updateImageLabel", () {
    tt("image's label is updated", () async {
      final labels = ["takoyaki", "sushi", "gyoza", "other"];
      final images = [
        const LabeledImage(id: 1, url: "img/01.png", label: "sushi"),
        const LabeledImage(id: 2, url: "img/02.png", label: "takoyaki"),
        const LabeledImage(id: 3, url: "img/03.png", label: "gyoza"),
        const LabeledImage(id: 4, url: "img/04.png", label: "sushi"),
      ];
      final updatedImages = [
        const LabeledImage(id: 1, url: "img/01.png", label: "sushi"),
        const LabeledImage(id: 2, url: "img/02.png", label: "takoyaki"),
        const LabeledImage(id: 3, url: "img/03.png", label: "sushi"),
        const LabeledImage(id: 4, url: "img/04.png", label: "sushi"),
      ];
      final annotationTask = AnnotationTask(labels: labels, images: images);
      await dataSource.saveAnnotationTask(annotationTask);
      await dataSource.updateImageLabel(3, 1);
      expect(labels, await dataSource.watchLabels().first);
      expect(updatedImages, await dataSource.watchImages().first);
    });
  });
}
