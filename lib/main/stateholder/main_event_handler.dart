import 'package:ikut_annotation_v2/model/my_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository.dart';
import 'main_ui_model_state_notifier_provider.dart';

part 'main_event_handler.g.dart';

class MainEventHandler {
  final MainUiModelStateNotifier _stateHolder;
  final Repository repository;

  MainEventHandler(this._stateHolder, this.repository);

  Future<void> load() async {
    try {
      await repository.load();
    } on MyException catch (e) {
      _stateHolder.setError(e.myError);
    }
  }

  void move({required int diff, required int imagesLength}) {
    _stateHolder.move(diff: diff, imagesLength: imagesLength);
  }

  void update({required int imageId, required int labelIndex}) {
    repository.updateImageLabel(imageId: imageId, labelIndex: labelIndex);
  }
}

@riverpod
MainEventHandler mainEventHandler(MainEventHandlerRef ref) {
  return MainEventHandler(ref.read(mainUiModelStateNotifierProvider.notifier),
      ref.read(repositoryProvider));
}
