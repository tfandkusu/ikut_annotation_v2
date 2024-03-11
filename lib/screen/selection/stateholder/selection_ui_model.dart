import 'package:freezed_annotation/freezed_annotation.dart';
part 'selection_ui_model.freezed.dart';

enum AnnotationTaskKind {
  sample,
  yours,
}

@freezed
class SelectionUiModel with _$SelectionUiModel {
  const factory SelectionUiModel(
      {required AnnotationTaskKind selectedAnnotationTaskKind,
      required String annotationTaskUrl,
      required bool progress,
      required bool showAnnotationTaskGuide,
      required bool back}) = _SelectionUiModel;
}
