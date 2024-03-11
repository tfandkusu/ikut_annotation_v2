import 'package:ikut_annotation_v2/data/annotation_task_provider.dart';
import 'package:ikut_annotation_v2/data/image_index_state_notifier_provider.dart';
import 'package:ikut_annotation_v2/screen/main/stateholder/main_ui_model.dart';
import 'package:ikut_annotation_v2/screen/main/stateholder/main_ui_model_state_notifier_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_ui_model_provider.g.dart';

@riverpod
MainUiModel mainUiModel(MainUiModelRef ref) {
  final annotationTaskAsyncValue = ref.watch(annotationTaskFutureProvider);
  final uiModel = ref.watch(mainUiModelStateNotifierProvider);
  final imageIndex = ref.watch(imageIndexStateNotifierProvider);
  final annotationTask = annotationTaskAsyncValue.value;
  if (annotationTask != null) {
    return uiModel.copyWith(
        labels: annotationTask.labels,
        images: annotationTask.images,
        progress: false,
        imageIndex: imageIndex.imageIndex,
        previousImageIndex: imageIndex.previousImageIndex);
  } else {
    return uiModel.copyWith(
        labels: [],
        images: [],
        progress: true,
        imageIndex: 0,
        previousImageIndex: 0);
  }
}
