import 'package:freezed_annotation/freezed_annotation.dart';

import 'labeled_image.dart';
part 'annotation_task.freezed.dart';

@freezed
class AnnotationTask with _$AnnotationTask {
  const factory AnnotationTask(
      {required List<String> labels,
      required List<LabeledImage> images}) = _AnnotationTask;
}
