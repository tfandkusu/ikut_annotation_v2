import 'package:ikut_annotation_v2/main/stateholder/main_ui_model.dart';
import 'package:ikut_annotation_v2/model/label_image.dart';
import 'package:ikut_annotation_v2/model/my_error.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/annotation_task.dart';
part 'main_ui_model_state_notifier_provider.g.dart';

@riverpod
class MainUiModelStateNotifier extends _$MainUiModelStateNotifier {
  @override
  MainUiModel build() => const MainUiModel(
      images: [],
      imageIndex: 0,
      previousImageIndex: 0,
      labels: [],
      progress: true,
      error: null,
      saveEffect: null);

  void setError(MyError? error) {
    state = state.copyWith(error: error, progress: false);
  }

  void setLoaded(AnnotationTask task) {
    state = state.copyWith(
        labels: task.labels, images: task.results, progress: false);
  }

  /// Update selected image
  void move(int diff) {
    int nextIndex = state.imageIndex + diff;
    if (nextIndex >= state.images.length) {
      nextIndex = state.images.length - 1;
    } else if (nextIndex < 0) {
      nextIndex = 0;
    }
    state = state.copyWith(
        imageIndex: nextIndex, previousImageIndex: state.imageIndex);
  }

  /// Update selected image's label
  void update(int labelIndex) async {
    if (labelIndex >= state.labels.length) {
      return;
    }
    String label = state.labels[labelIndex];
    List<LabeledImage> images = List.from(state.images);
    var image = state.images[state.imageIndex];
    image = image.copyWith(label: label);
    images[state.imageIndex] = image;
    state = state.copyWith(images: images, progress: false);
  }

  void startSave() {
    state = state.copyWith(saveEffect: state.images, progress: true);
  }

  void onSaveStarted() {
    state = state.copyWith(saveEffect: null);
  }

  void onSaveFinished() {
    state = state.copyWith(progress: false);
  }
}
