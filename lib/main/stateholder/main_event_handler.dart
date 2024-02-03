import 'package:ikut_annotation_v2/model/my_exception.dart';

import '../../data/repository.dart';
import 'main_ui_model_state_notifier_provider.dart';

class MainEventHandler {
  final MainUiModelStateNotifier _stateHolder;
  final Repository repository;

  MainEventHandler(this._stateHolder, this.repository);

  void load() async {
    try {
      final annotationTask = await repository.load();
      _stateHolder.setLoaded(annotationTask);
    } on MyException catch (e) {
      _stateHolder.setError(e.myError);
    }
  }
}