import 'package:ikut_annotation_v2/data/image_index_state_notifier_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repository.dart';
import 'main_ui_model_state_notifier_provider.dart';

part 'main_event_handler.g.dart';

class MainEventHandler {
  final MainUiModelStateNotifier _stateHolder;
  final ImageIndexStateNotifier _imageIndexStateNotifier;
  final Repository repository;

  MainEventHandler(
      this._stateHolder, this._imageIndexStateNotifier, this.repository);

  Future<void> load() async {
    await repository.load();
  }

  void move({required int diff, required int imagesLength}) {
    _imageIndexStateNotifier.move(diff: diff, imagesLength: imagesLength);
  }

  void update({required int imageId, required int labelIndex}) {
    repository.updateImageLabel(imageId: imageId, labelIndex: labelIndex);
  }

  void onClickSelectAnnotationJob() {
    _stateHolder.setShowAnnotationTaskSelectionEffect(true);
  }

  void onNavigateToAnnotationJobSelection() {
    _stateHolder.setShowAnnotationTaskSelectionEffect(false);
  }
}

@riverpod
MainEventHandler mainEventHandler(MainEventHandlerRef ref) {
  return MainEventHandler(
      ref.read(mainUiModelStateNotifierProvider.notifier),
      ref.read(imageIndexStateNotifierProvider.notifier),
      ref.read(repositoryProvider));
}
