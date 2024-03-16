import 'package:freezed_annotation/freezed_annotation.dart';

part 'selection_ui_model.freezed.dart';

@freezed
class SelectionUiModel with _$SelectionUiModel {
  const factory SelectionUiModel(
      {required bool canPop,
      required bool openSampleTaskButtonEnabled,
      required String annotationTaskUrl,
      required bool openYourTaskButtonEnabled,
      required bool progress,
      required bool errorEffect,
      required bool showAnnotationTaskGuideEffect,
      required bool backEffect}) = _SelectionUiModel;
}
