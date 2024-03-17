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
  tw("setShowAnnotationTaskSelectionEffect", () {
    tt("update showAnnotationTaskSelectionEffect", () {
      stateNotifier.setShowAnnotationTaskSelectionEffect(true);
      expect(
          getState(),
          const MainUiModel(
              images: [],
              imageIndex: 0,
              previousImageIndex: 0,
              labels: [],
              progress: true,
              showAnnotationTaskSelectionEffect: true,
              callSendAppEffect: null));
    });
  });
}
