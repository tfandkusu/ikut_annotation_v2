import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikut_annotation_v2/data/image_index_state_notifier_provider.dart';
import 'package:ikut_annotation_v2/data/repository.dart';
import 'package:ikut_annotation_v2/model/image_index.dart';
import 'package:ikut_annotation_v2/screen/main/stateholder/main_event_handler.dart';
import 'package:ikut_annotation_v2/screen/main/stateholder/main_ui_model.dart';
import 'package:ikut_annotation_v2/screen/main/stateholder/main_ui_model_state_notifier_provider.dart';
import 'package:ikut_annotation_v2/model/annotation_task.dart';
import 'package:ikut_annotation_v2/model/labeled_image.dart';
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
  const images = [
    LabeledImage(id: 1, url: "img/01.png", label: "sushi"),
    LabeledImage(id: 2, url: "img/02.png", label: "takoyaki"),
    LabeledImage(id: 3, url: "img/03.png", label: "gyoza"),
    LabeledImage(id: 4, url: "img/04.png", label: "sushi"),
  ];
  const labels = ["takoyaki", "sushi", "gyoza"];
  const annotationTask = AnnotationTask(labels: labels, images: images);
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
  tg("load success", () {
    tw("load", () {
      tt("Repository#load is called", () async {
        when(() => repository.load()).thenAnswer((_) async => annotationTask);
        await eventHandler.load();
        verifyInOrder([
          () => repository.load(),
        ]);
      });
    });
  });
  // TODO load error
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
    tt("StateNotifier#setShowAnnotationTaskSelection(true) is called", () {
      eventHandler.onClickSelectAnnotationJob();
      verify(() => stateNotifier.setShowAnnotationTaskSelection(true));
    });
  });
  tw("onNavigateToAnnotationJobSelection", () {
    tt("StateNotifier#setShowAnnotationTaskSelection(false) is called", () {
      eventHandler.onNavigateToAnnotationJobSelection();
      verify(() => stateNotifier.setShowAnnotationTaskSelection(false));
    });
  });
}
