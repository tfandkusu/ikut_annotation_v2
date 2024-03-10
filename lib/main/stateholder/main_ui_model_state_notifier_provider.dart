import 'package:ikut_annotation_v2/main/stateholder/main_ui_model.dart';
import 'package:ikut_annotation_v2/model/my_error.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
      error: null);

  void setError(MyError? error) {
    state = state.copyWith(error: error, progress: false);
  }

  /// Update selected image
  void move({required int diff, required int imagesLength}) {
    int nextIndex = state.imageIndex + diff;
    if (nextIndex >= imagesLength) {
      nextIndex = imagesLength - 1;
    } else if (nextIndex < 0) {
      nextIndex = 0;
    }
    state = state.copyWith(
        imageIndex: nextIndex, previousImageIndex: state.imageIndex);
  }
}
