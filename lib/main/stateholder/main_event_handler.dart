import 'package:ikut_annotation_v2/model/my_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository.dart';
import '../../model/labeled_image.dart';
import 'main_ui_model_state_notifier_provider.dart';

part 'main_event_handler.g.dart';

class MainEventHandler {
  final MainUiModelStateNotifier _stateHolder;
  final Repository repository;

  MainEventHandler(this._stateHolder, this.repository);

  Future<void> load() async {
    try {
      final annotationTask = await repository.load();
      _stateHolder.setLoaded(annotationTask);
    } on MyException catch (e) {
      _stateHolder.setError(e.myError);
    }
  }

  void move(int diff) {
    _stateHolder.move(diff);
  }

  void update(int labelIndex) {
    _stateHolder.update(labelIndex);
    _stateHolder.startSave();
  }

  Future<void> save(List<LabeledImage> images) async {
    _stateHolder.onSaveStarted();
    try {
      await repository.saveResults(images);
    } on MyException catch (e) {
      _stateHolder.setError(e.myError);
    } finally {
      _stateHolder.onSaveFinished();
    }
  }
}

@riverpod
MainEventHandler mainEventHandler(MainEventHandlerRef ref) {
  return MainEventHandler(ref.read(mainUiModelStateNotifierProvider.notifier),
      ref.read(repositoryProvider));
}
