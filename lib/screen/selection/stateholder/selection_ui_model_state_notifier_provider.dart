import 'package:ikut_annotation_v2/screen/selection/stateholder/selection_ui_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selection_ui_model_state_notifier_provider.g.dart';

@riverpod
class SelectionUiModelStateNotifier extends _$SelectionUiModelStateNotifier {
  @override
  SelectionUiModel build() => const SelectionUiModel(
      canPop: false,
      openSampleTaskButtonEnabled: true,
      annotationTaskUrl: "",
      progress: true,
      showAnnotationTaskGuideEffect: false,
      backEffect: false);

  void setCanPop(canPop) {
    state = state.copyWith(canPop: canPop, progress: false);
  }

  void setAnnotationTaskUrl(String annotationTaskUrl) {
    state = state.copyWith(
        annotationTaskUrl: annotationTaskUrl,
        openSampleTaskButtonEnabled: annotationTaskUrl.isEmpty);
  }

  void setProgress(bool progress) {
    state = state.copyWith(progress: progress);
  }

  void setShowAnnotationTaskGuideEffect(bool show) {
    state = state.copyWith(showAnnotationTaskGuideEffect: show);
  }

  void setBackEffect(bool backEffect) {
    state = state.copyWith(backEffect: backEffect);
  }
}
