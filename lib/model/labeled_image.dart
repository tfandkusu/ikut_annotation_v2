import 'package:freezed_annotation/freezed_annotation.dart';
part 'label_image.freezed.dart';

@freezed
class LabeledImage with _$LabeledImage {
  const factory LabeledImage(
      {required int id,
      required String url,
      required String label}) = _LabeledImage;
}
