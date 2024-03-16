import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'localication_en.dart';
part 'localization.g.dart';

@riverpod
Localization localization(LocalizationRef ref) {
  return LocalizationEn();
}

abstract base class Localization {
  String get appName;
  String get selectionTitle;
  String get selectionSampleSubTitle;
  String get selectionOpenSampleTask;
  String get selectionYourSubTitle;
  String get selectionAnnotationTaskUrl;
  String get selectionAnnotationTaskUrlPlaceHolder;
  String get selectionHowToDefineAnnotationTask;
  String get selectionOpenYourTask;
}
