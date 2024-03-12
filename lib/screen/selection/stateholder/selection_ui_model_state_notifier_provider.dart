import 'package:ikut_annotation_v2/screen/selection/stateholder/selection_ui_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selection_ui_model_state_notifier_provider.g.dart';

@riverpod
class SelectionUiModelStateNotifier extends _$SelectionUiModelStateNotifier {
  @override
  SelectionUiModel build() => const SelectionUiModel(
      selectedAnnotationTaskKind: AnnotationTaskKind.sample,
      annotationTaskUrl: "https://ikut-annotation-sample.web.app/task.yaml",
      progress: false,
      showAnnotationTaskGuideEffect: false,
      backEffect: false);

  void setSelectedAnnotationTaskKind(AnnotationTaskKind kind) {
    state = state.copyWith(selectedAnnotationTaskKind: kind);
  }

  void setAnnotationTaskUrl(String annotationTaskUrl) {
    state = state.copyWith(annotationTaskUrl: annotationTaskUrl);
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
