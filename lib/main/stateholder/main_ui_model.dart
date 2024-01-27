import 'package:freezed_annotation/freezed_annotation.dart';
import '../../model/label_image.dart';
import '../../model/my_error.dart';
part 'main_ui_model.freezed.dart';

@freezed
class MainUiModel with _$MainUiModel {
  const factory MainUiModel(
      {required List<LabeledImage> images,
      required int imageIndex,
      required int previousImageIndex,
      required List<String> labels,
      required bool writing,
      required MyError? error}) = _MainUiModel;
}
