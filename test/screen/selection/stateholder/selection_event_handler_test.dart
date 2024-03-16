import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikut_annotation_v2/data/image_index_state_notifier_provider.dart';
import 'package:ikut_annotation_v2/data/repository.dart';
import 'package:ikut_annotation_v2/model/image_index.dart';
import 'package:ikut_annotation_v2/screen/selection/stateholder/selection_event_handler.dart';

import 'package:ikut_annotation_v2/screen/selection/stateholder/selection_ui_model.dart';
import 'package:ikut_annotation_v2/screen/selection/stateholder/selection_ui_model_state_notifier_provider.dart';
import 'package:mocktail/mocktail.dart';

import '../../../util/helper.dart';
import '../../../util/provider_container.dart';

class SelectionUiModelStateNotifierMock
    extends AutoDisposeNotifier<SelectionUiModel>
    with Mock
    implements SelectionUiModelStateNotifier {}

class ImageIndexStateNotifierMock extends Notifier<ImageIndex>
    with Mock
    implements ImageIndexStateNotifier {}

class RepositoryMock extends Mock implements Repository {}

void main() {
  late ProviderContainer container;
  late SelectionEventHandler eventHandler;
  late RepositoryMock repository;
  late SelectionUiModelStateNotifierMock stateNotifier;
  late ImageIndexStateNotifierMock imageIndexStateNotifier;
  setUp(() {
    repository = RepositoryMock();
    stateNotifier = SelectionUiModelStateNotifierMock();
    imageIndexStateNotifier = ImageIndexStateNotifierMock();
    container = createContainer(
      overrides: [
        repositoryProvider.overrideWith((ref) => repository),
        selectionUiModelStateNotifierProvider.overrideWith(() => stateNotifier),
        imageIndexStateNotifierProvider
            .overrideWith(() => imageIndexStateNotifier)
      ],
    );
    eventHandler = container.read(selectionEventHandlerProvider);
  });
  tg("AnnotationTask is loaded", () {
    tw("onCreate", () {
      tt("uiModel's canPop is true", () async {
        when(() => repository.hasAnnotationTask())
            .thenAnswer((_) async => true);
        await eventHandler.onCreate();
        verify(() => stateNotifier.setCanPop(true));
      });
    });
  });
  tg("AnnotationTask is not loaded", () {
    tw("onCreate", () {
      tt("uiModel's canPop is false", () async {
        when(() => repository.hasAnnotationTask())
            .thenAnswer((_) async => false);
        await eventHandler.onCreate();
        verify(() => stateNotifier.setCanPop(false));
      });
    });
  });
  tw("setAnnotationTaskUrl", () {
    tt("uiModel's annotationTaskUrl is updated", () {
      const annotationTaskUrl = "https://example.com/task.yaml";
      eventHandler.setAnnotationTaskUrl(annotationTaskUrl);
      verify(() => stateNotifier.setAnnotationTaskUrl(annotationTaskUrl));
    });
  });
  tg("load success", () {
    tw("onClickSampleTask", () {
      tt("AnnotationTask is loaded, image's index is reset and back to main",
          () async {
        const sampleTaskUrl =
            "https://ikut-annotation-sample.web.app/task.yaml";
        when(() => repository.load(sampleTaskUrl)).thenAnswer((_) async {});
        await eventHandler.onClickSampleTask();
        verifyInOrder([
          () => stateNotifier.setProgress(true),
          () => repository.load(sampleTaskUrl),
          () => imageIndexStateNotifier.reset(),
          () => stateNotifier.setBackEffect(true),
        ]);
      });
    });
  });
  tg("load failed", () {
    tw("onClickSampleTask", () {
      tt("Error is shown", () async {
        const sampleTaskUrl =
            "https://ikut-annotation-sample.web.app/task.yaml";
        when(() => repository.load(sampleTaskUrl)).thenThrow(Exception());
        await eventHandler.onClickSampleTask();
        verifyInOrder([
          () => stateNotifier.setProgress(true),
          () => repository.load(sampleTaskUrl),
          () => stateNotifier.setError(true),
        ]);
      });
    });
  });
  tw("onClickYourTask", () {
    tt("AnnotationTask is loaded, image's index is reset and back to main",
        () async {
      const taskUrl = "https://example.com/task.yaml";
      when(() => repository.load(taskUrl)).thenAnswer((_) async {});
      await eventHandler.onClickYourTask(taskUrl);
      verifyInOrder([
        () => stateNotifier.setProgress(true),
        () => repository.load(taskUrl),
        () => imageIndexStateNotifier.reset(),
        () => stateNotifier.setBackEffect(true),
      ]);
    });
  });
  tw("onClickAnnotationTaskGuide", () {
    tt("uiModel's howAnnotationTaskGuideEffect is true", () {
      eventHandler.onClickAnnotationTaskGuide();
      verify(() => stateNotifier.setShowAnnotationTaskGuideEffect(true));
    });
  });
  tw("onShownAnnotationTaskGuide", () {
    tt("uiModel's howAnnotationTaskGuideEffect is false", () {
      eventHandler.onShownAnnotationTaskGuide();
      verify(() => stateNotifier.setShowAnnotationTaskGuideEffect(false));
    });
  });
  tw("onShownErrorDialog", () {
    tt("uiModel's error is false", () {
      eventHandler.onShownErrorDialog();
      verify(() => stateNotifier.setError(false));
    });
  });
}
