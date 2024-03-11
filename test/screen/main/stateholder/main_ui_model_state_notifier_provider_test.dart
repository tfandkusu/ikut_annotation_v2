import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikut_annotation_v2/screen/main/stateholder/main_ui_model.dart';
import 'package:ikut_annotation_v2/screen/main/stateholder/main_ui_model_state_notifier_provider.dart';

import '../../../util/helper.dart';
import '../../../util/provider_container.dart';

void main() {
  late ProviderContainer container;
  late MainUiModelStateNotifier stateNotifier;
  setUp(() {
    container = createContainer();
    stateNotifier = container.read(mainUiModelStateNotifierProvider.notifier);
  });
  getState() => container.read(mainUiModelStateNotifierProvider);
  tw("move", () {
    tt("update imageIndex and previous index", () {
      stateNotifier.move(diff: 1, imagesLength: 3);
      expect(
          getState(),
          const MainUiModel(
              images: [],
              imageIndex: 1,
              previousImageIndex: 0,
              labels: [],
              progress: true,
              error: null,
              showAnnotationTaskSelection: false));
      stateNotifier.move(diff: 2, imagesLength: 5);
      expect(
          getState(),
          const MainUiModel(
              images: [],
              imageIndex: 3,
              previousImageIndex: 1,
              labels: [],
              progress: true,
              error: null,
              showAnnotationTaskSelection: false));
    });
  });
  tw("move under zero", () {
    tt("update imageIndex to 0", () {
      stateNotifier.move(diff: -1, imagesLength: 3);
      expect(
          getState(),
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
  tw("move over images.count", () {
    tt("update imageIndex to images.count - 1", () {
      stateNotifier.move(diff: 3, imagesLength: 3);
      expect(
          getState(),
          const MainUiModel(
              images: [],
              imageIndex: 2,
              previousImageIndex: 0,
              labels: [],
              progress: true,
              error: null,
              showAnnotationTaskSelection: false));
    });
  });
  tw("setShowAnnotationTaskSelection", () {
    tt("update showAnnotationTaskSelection", () {
      stateNotifier.setShowAnnotationTaskSelection(true);
      expect(
          getState(),
          const MainUiModel(
              images: [],
              imageIndex: 0,
              previousImageIndex: 0,
              labels: [],
              progress: true,
              error: null,
              showAnnotationTaskSelection: true));
    });
  });
}
