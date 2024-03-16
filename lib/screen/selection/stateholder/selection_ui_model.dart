import 'package:freezed_annotation/freezed_annotation.dart';
part 'selection_ui_model.freezed.dart';

@freezed
class SelectionUiModel with _$SelectionUiModel {
  const factory SelectionUiModel(
      {required bool canPop,
      required String annotationTaskUrl,
      required bool progress,
      required bool showAnnotationTaskGuideEffect,
      required bool backEffect}) = _SelectionUiModel;
}
