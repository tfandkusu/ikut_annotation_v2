import 'package:ikut_annotation_v2/screen/selection/stateholder/selection_ui_model.dart';
import 'package:ikut_annotation_v2/screen/selection/stateholder/selection_ui_model_state_notifier_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selection_ui_model_provider.g.dart';

@riverpod
SelectionUiModel selectionUiModel(SelectionUiModelRef ref) {
  return ref.watch(selectionUiModelStateNotifierProvider);
}
