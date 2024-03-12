import 'package:ikut_annotation_v2/data/image_index_state_notifier_provider.dart';
import 'package:ikut_annotation_v2/data/repository.dart';
import 'package:ikut_annotation_v2/screen/selection/stateholder/selection_ui_model.dart';
import 'package:ikut_annotation_v2/screen/selection/stateholder/selection_ui_model_state_notifier_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selection_event_handler.g.dart';

class SelectionEventHandler {
  final SelectionUiModelStateNotifier _stateNotifier;
  final Repository _repository;
  final ImageIndexStateNotifier _imageIndexStateNotifier;

  SelectionEventHandler(
      this._stateNotifier, this._repository, this._imageIndexStateNotifier);

  void selectAnnotationTaskKind(AnnotationTaskKind kind) {
    _stateNotifier.setSelectedAnnotationTaskKind(kind);
  }

  void setAnnotationTaskUrl(String annotationTaskUrl) {
    _stateNotifier.setAnnotationTaskUrl(annotationTaskUrl);
  }

  Future<void> onClickLoad(String taskUrl) async {
    _stateNotifier.setProgress(true);
    await _repository.load(taskUrl);
    _imageIndexStateNotifier.reset();
    _stateNotifier.setBackEffect(true);
  }

  void onClickAnnotationTaskGuide() {
    _stateNotifier.setShowAnnotationTaskGuideEffect(true);
  }

  void onShownAnnotationTaskGuide() {
    _stateNotifier.setShowAnnotationTaskGuideEffect(false);
  }
}

@riverpod
SelectionEventHandler selectionEventHandler(SelectionEventHandlerRef ref) {
  return SelectionEventHandler(
    ref.read(selectionUiModelStateNotifierProvider.notifier),
    ref.read(repositoryProvider),
    ref.read(imageIndexStateNotifierProvider.notifier),
  );
}
