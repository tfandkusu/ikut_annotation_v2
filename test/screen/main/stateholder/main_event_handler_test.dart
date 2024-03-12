import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikut_annotation_v2/data/image_index_state_notifier_provider.dart';
import 'package:ikut_annotation_v2/data/repository.dart';
import 'package:ikut_annotation_v2/model/image_index.dart';
import 'package:ikut_annotation_v2/screen/main/stateholder/main_event_handler.dart';
import 'package:ikut_annotation_v2/screen/main/stateholder/main_ui_model.dart';
import 'package:ikut_annotation_v2/screen/main/stateholder/main_ui_model_state_notifier_provider.dart';
import 'package:mocktail/mocktail.dart';

import '../../../util/helper.dart';
import '../../../util/provider_container.dart';

class MainUiModelStateNotifierMock extends AutoDisposeNotifier<MainUiModel>
    with Mock
    implements MainUiModelStateNotifier {}

class ImageIndexStateNotifierMock extends Notifier<ImageIndex>
    with Mock
    implements ImageIndexStateNotifier {}

class RepositoryMock extends Mock implements Repository {}

void main() {
  late ProviderContainer container;
  late MainEventHandler eventHandler;
  late RepositoryMock repository;
  late MainUiModelStateNotifierMock stateNotifier;
  late ImageIndexStateNotifierMock imageIndexStateNotifier;
  setUp(() {
    repository = RepositoryMock();
    stateNotifier = MainUiModelStateNotifierMock();
    imageIndexStateNotifier = ImageIndexStateNotifierMock();
    container = createContainer(
      overrides: [
        repositoryProvider.overrideWith((ref) => repository),
        mainUiModelStateNotifierProvider.overrideWith(() => stateNotifier),
        imageIndexStateNotifierProvider
            .overrideWith(() => imageIndexStateNotifier)
      ],
    );
    eventHandler = container.read(mainEventHandlerProvider);
  });
  tg("Annotation task is loaded", () {
    tw("onCreate", () {
      tt("setShowAnnotationTaskSelectionEffect(true) is called", () async {
        when(() => repository.hasAnnotationTask())
            .thenAnswer((_) async => true);
        await eventHandler.onCreate();
        verifyInOrder([
          () => repository.hasAnnotationTask(),
          () => stateNotifier.setShowAnnotationTaskSelectionEffect(true),
        ]);
      });
    });
  });
  tg("Annotation task is not loaded", () {
    tw("onCreate", () {
      tt("setShowAnnotationTaskSelectionEffect(true) is not called", () async {
        when(() => repository.hasAnnotationTask())
            .thenAnswer((_) async => false);
        await eventHandler.onCreate();
        verifyInOrder([() => repository.hasAnnotationTask()]);
        verifyNever(
            () => stateNotifier.setShowAnnotationTaskSelectionEffect(true));
      });
    });
  });
  tw("onNavigateToSelection", () {
    tt("StateNotifier#setShowAnnotationTaskSelectionEffect(false) is called",
        () {
      eventHandler.onNavigateToSelection();
      verify(() => stateNotifier.setShowAnnotationTaskSelectionEffect(false));
    });
  });
  tw("move", () {
    tt("StateNotifier#move is called", () {
      eventHandler.move(diff: 1, imagesLength: 300);
      verify(() => imageIndexStateNotifier.move(diff: 1, imagesLength: 300));
    });
  });
  tw("update", () {
    tt("Repository#update is called", () {
      when(() => repository.updateImageLabel(imageId: 1, labelIndex: 2))
          .thenAnswer((_) async {});
      eventHandler.update(imageId: 1, labelIndex: 2);
      verify(() => repository.updateImageLabel(imageId: 1, labelIndex: 2));
    });
  });
  tw("onClickSelectAnnotationJob", () {
    tt("StateNotifier#setShowAnnotationTaskSelectionEffect(true) is called",
        () {
      eventHandler.onClickSelectAnnotationJob();
      verify(() => stateNotifier.setShowAnnotationTaskSelectionEffect(true));
    });
  });
  tw("onNavigateToAnnotationJobSelection", () {
    tt("StateNotifier#setShowAnnotationTaskSelectionEffect(false) is called",
        () {
      eventHandler.onNavigateToAnnotationJobSelection();
      verify(() => stateNotifier.setShowAnnotationTaskSelectionEffect(false));
    });
  });
}
