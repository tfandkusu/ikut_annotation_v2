import 'package:ikut_annotation_v2/screen/main/stateholder/main_ui_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_ui_model_state_notifier_provider.g.dart';

@riverpod
class MainUiModelStateNotifier extends _$MainUiModelStateNotifier {
  @override
  MainUiModel build() => const MainUiModel(
      images: [],
      imageIndex: 0,
      previousImageIndex: 0,
      labels: [],
      progress: true,
      showAnnotationTaskSelectionEffect: false);

  void setShowAnnotationTaskSelectionEffect(bool show) {
    state = state.copyWith(showAnnotationTaskSelectionEffect: show);
  }
}
