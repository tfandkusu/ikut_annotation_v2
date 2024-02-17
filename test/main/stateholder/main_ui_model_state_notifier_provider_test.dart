import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikut_annotation_v2/main/stateholder/main_ui_model.dart';
import 'package:ikut_annotation_v2/main/stateholder/main_ui_model_state_notifier_provider.dart';
import 'package:ikut_annotation_v2/model/annotation_task.dart';
import 'package:ikut_annotation_v2/model/label_image.dart';
import 'package:ikut_annotation_v2/model/my_error.dart';

import '../../util/helper.dart';
import '../../util/provider_container.dart';

void main() {
  const images = [
    LabeledImage(path: "img/01.png", label: "sushi"),
    LabeledImage(path: "img/02.png", label: "takoyaki"),
    LabeledImage(path: "img/03.png", label: "gyoza"),
    LabeledImage(path: "img/04.png", label: "sushi"),
  ];
  const labels = ["takoyaki", "sushi", "gyoza"];
  const annotationTask = AnnotationTask(labels: labels, results: images);
  late ProviderContainer container;
  late MainUiModelStateNotifier stateNotifier;
  setUp(() {
    container = createContainer();
    stateNotifier = container.read(mainUiModelStateNotifierProvider.notifier);
  });
  getState() => container.read(mainUiModelStateNotifierProvider);
  tw("setLoaded", () {
    tt("set image and labels", () {
      expect(
          getState(),
          const MainUiModel(
              images: [],
              imageIndex: 0,
              previousImageIndex: 0,
              labels: [],
              progress: true,
              error: null,
              saveEffect: false));
      stateNotifier.setLoaded(annotationTask);
      expect(
          getState(),
          const MainUiModel(
              images: images,
              imageIndex: 0,
              previousImageIndex: 0,
              labels: labels,
              progress: false,
              error: null,
              saveEffect: false));
    });
  });
  tw("move", () {
    tt("update imageIndex and previous index", () {
      stateNotifier.setLoaded(annotationTask);
      stateNotifier.move(1);
      expect(
          getState(),
          const MainUiModel(
              images: images,
              imageIndex: 1,
              previousImageIndex: 0,
              labels: labels,
              progress: false,
              error: null,
              saveEffect: false));
      stateNotifier.move(2);
      expect(
          getState(),
          const MainUiModel(
              images: images,
              imageIndex: 3,
              previousImageIndex: 1,
              labels: labels,
              progress: false,
              error: null,
              saveEffect: false));
    });
  });
  tw("move under zero", () {
    tt("update imageIndex to 0", () {
      stateNotifier.setLoaded(annotationTask);
      stateNotifier.move(-1);
      expect(
          getState(),
          const MainUiModel(
              images: images,
              imageIndex: 0,
              previousImageIndex: 0,
              labels: labels,
              progress: false,
              error: null,
              saveEffect: false));
    });
  });
  tw("move over images.count", () {
    tt("update imageIndex to images.count - 1", () {
      stateNotifier.setLoaded(annotationTask);
      stateNotifier.move(4);
      expect(
          getState(),
          const MainUiModel(
              images: images,
              imageIndex: 3,
              previousImageIndex: 0,
              labels: labels,
              progress: false,
              error: null,
              saveEffect: false));
    });
  });

  tw("setProgressAsTrue", () {
    tt("progress is true", () {
      stateNotifier.setLoaded(annotationTask);
      stateNotifier.setProgressAsTrue();
      expect(
          getState(),
          const MainUiModel(
              images: images,
              imageIndex: 0,
              previousImageIndex: 0,
              labels: labels,
              progress: true,
              error: null,
              saveEffect: false));
    });
  });

  tw("update", () {
    tt("label is updated", () {
      stateNotifier.setLoaded(annotationTask);
      stateNotifier.move(2);
      stateNotifier.update(1);
      expect(
          getState(),
          const MainUiModel(
              images: [
                LabeledImage(path: "img/01.png", label: "sushi"),
                LabeledImage(path: "img/02.png", label: "takoyaki"),
                LabeledImage(path: "img/03.png", label: "sushi"),
                LabeledImage(path: "img/04.png", label: "sushi"),
              ],
              imageIndex: 2,
              previousImageIndex: 0,
              labels: labels,
              progress: false,
              error: null,
              saveEffect: false));
    });
  });
  tw("setError", () {
    tt("error is updated", () {
      stateNotifier.setLoaded(annotationTask);
      stateNotifier.setProgressAsTrue();
      stateNotifier.setError(const MyError.readFile("label.txt"));
      expect(
          getState(),
          const MainUiModel(
              images: images,
              imageIndex: 0,
              previousImageIndex: 0,
              labels: labels,
              progress: false,
              error: MyError.readFile("label.txt"),
              saveEffect: false));
    });
  });
  tw("save and onSaved", () {
    tt("saveEffect is changed", () {
      stateNotifier.setLoaded(annotationTask);
      stateNotifier.save();
      expect(
          getState(),
          const MainUiModel(
              images: images,
              imageIndex: 0,
              previousImageIndex: 0,
              labels: labels,
              progress: false,
              error: null,
              saveEffect: true));
      stateNotifier.onSaved();
      expect(
          getState(),
          const MainUiModel(
              images: images,
              imageIndex: 0,
              previousImageIndex: 0,
              labels: labels,
              progress: false,
              error: null,
              saveEffect: false));
    });
  });
}
