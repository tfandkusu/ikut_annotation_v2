part of 'localization.dart';

final class LocalizationEn extends Localization {
  @override
  String get appName => "iKut Annotation";

  @override
  String get selectionTitle => "Select annotation task";

  @override
  String get selectionOpenSampleTask => "Open sample annotation task";

  @override
  String get selectionOpenYourTask => "Open your annotation task";

  @override
  String get selectionAnnotationTaskUrl => "Your annotation task URL";

  @override
  String get selectionSampleSubTitle => "Sample annotation task";

  @override
  String get selectionYourSubTitle => "Your annotation task";

  @override
  String get selectionAnnotationTaskUrlPlaceHolder =>
      "https://ikut-annotation-sample.web.app/task.yaml";
}
