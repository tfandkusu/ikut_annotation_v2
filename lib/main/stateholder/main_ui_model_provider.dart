import 'package:ikut_annotation_v2/main/stateholder/main_ui_model.dart';
import 'package:ikut_annotation_v2/main/stateholder/main_ui_model_state_notifier_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_ui_model_provider.g.dart';

@riverpod
MainUiModel mainUiModel(MainUiModelRef ref) {
  final uiModel = ref.watch(mainUiModelStateNotifierProvider);
  return uiModel;
}
