import 'package:freezed_annotation/freezed_annotation.dart';
part 'image_index.freezed.dart';

@freezed
class ImageIndex with _$ImageIndex {
  const factory ImageIndex(
      {required int imageIndex, required int previousImageIndex}) = _ImageIndex;
}
