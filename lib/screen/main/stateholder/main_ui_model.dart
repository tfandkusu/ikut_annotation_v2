import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../model/labeled_image.dart';
import '../../../model/my_error.dart';
part 'main_ui_model.freezed.dart';

@freezed
class MainUiModel with _$MainUiModel {
  const factory MainUiModel(
      {required List<LabeledImage> images,
      required int imageIndex,
      required int previousImageIndex,
      required List<String> labels,
      required bool progress,
      required MyError? error,
      required bool showAnnotationTaskSelection}) = _MainUiModel;
}

extension MainUiModelExtension on MainUiModel {
  bool isLoaded() {
    return images.isNotEmpty && labels.isNotEmpty;
  }

  LabeledImage getCurrentImage() {
    return images[imageIndex];
  }

  LabeledImage getPreviousImage() {
    return images[previousImageIndex];
  }
}
