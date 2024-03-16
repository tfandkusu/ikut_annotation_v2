import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikut_annotation_v2/screen/selection/stateholder/selection_ui_model.dart';
import 'package:ikut_annotation_v2/screen/selection/stateholder/selection_ui_model_state_notifier_provider.dart';

import '../../../util/helper.dart';
import '../../../util/provider_container.dart';

void main() {
  late ProviderContainer container;
  late SelectionUiModelStateNotifier stateNotifier;
  setUp(() {
    container = createContainer();
    stateNotifier =
        container.read(selectionUiModelStateNotifierProvider.notifier);
  });
  getState() => container.read(selectionUiModelStateNotifierProvider);
  tw("setCanPop", () {
    tt("update canPop and progress", () {
      stateNotifier.setCanPop(true);
      expect(
          getState(),
          const SelectionUiModel(
              canPop: true,
              openSampleTaskButtonEnabled: true,
              annotationTaskUrl: "",
              progress: false,
              showAnnotationTaskGuideEffect: false,
              backEffect: false));
    });
  });
  tw("setAnnotationTaskUrl", () {
    tt("update annotationTaskUrl and openSampleTaskButtonEnabled to false", () {
      stateNotifier.setAnnotationTaskUrl("https://");
      expect(
          getState(),
          const SelectionUiModel(
              canPop: false,
              openSampleTaskButtonEnabled: false,
              annotationTaskUrl: "https://",
              progress: true,
              showAnnotationTaskGuideEffect: false,
              backEffect: false));
    });
  });
}
