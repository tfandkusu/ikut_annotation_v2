import 'package:flutter_test/flutter_test.dart';
import 'package:ikut_annotation_v2/data/annotation_task_provider.dart';
import 'package:ikut_annotation_v2/screen/main/stateholder/main_ui_model.dart';
import 'package:ikut_annotation_v2/screen/main/stateholder/main_ui_model_provider.dart';
import 'package:ikut_annotation_v2/model/annotation_task.dart';
import 'package:ikut_annotation_v2/model/labeled_image.dart';

import '../../../util/helper.dart';
import '../../../util/provider_container.dart';

void main() {
  tg("AnnotationTask is loaded", () {
    tw("read mainUiModelProvider", () {
      tt("labels and images of MainUiModel are set", () {
        final labels = ["takoyaki", "sushi", "gyoza", "other"];
        final images = [
          const LabeledImage(
              id: 1,
              url: "https://ikut-annotation-sample.web.app/image/1002013.jpg",
              label: "sushi"),
          const LabeledImage(
              id: 2,
              url: "https://ikut-annotation-sample.web.app/image/1002167.jpg",
              label: "takoyaki"),
          const LabeledImage(
              id: 3,
              url: "https://ikut-annotation-sample.web.app/image/1002237.jpg",
              label: "gyoza"),
          const LabeledImage(
              id: 4,
              url: "https://ikut-annotation-sample.web.app/image/1003289.jpg",
              label: "sushi"),
        ];
        final annotationTask = AnnotationTask(labels: labels, images: images);
        final container = createContainer(
          overrides: [
            annotationTaskFutureProvider.overrideWith((ref) => annotationTask)
          ],
        );
        final mainUiModel = container.read(mainUiModelProvider);
        expect(
            mainUiModel,
            MainUiModel(
                images: images,
                imageIndex: 0,
                previousImageIndex: 0,
                labels: labels,
                progress: false,
                error: null,
                showAnnotationTaskSelection: false));
      });
    });
  });
  tg("AnnotationTask is not loaded", () {
    tw("read mainUiModelProvider", () {
      tt("labels and images of MainUiModel are empty", () {
        final container = createContainer(
          overrides: [
            annotationTaskStreamProvider
                .overrideWith((ref) => const Stream.empty())
          ],
        );
        final mainUiModel = container.read(mainUiModelProvider);
        expect(
            mainUiModel,
            const MainUiModel(
                images: [],
                imageIndex: 0,
                previousImageIndex: 0,
                labels: [],
                progress: true,
                error: null,
                showAnnotationTaskSelection: false));
      });
    });
  });
}
