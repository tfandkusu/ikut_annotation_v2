import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikut_annotation_v2/data/repository.dart';
import 'package:ikut_annotation_v2/main/stateholder/main_event_handler.dart';
import 'package:ikut_annotation_v2/main/stateholder/main_ui_model.dart';
import 'package:ikut_annotation_v2/main/stateholder/main_ui_model_state_notifier_provider.dart';
import 'package:ikut_annotation_v2/model/annotation_task.dart';
import 'package:ikut_annotation_v2/model/label_image.dart';
import 'package:ikut_annotation_v2/model/my_error.dart';
import 'package:ikut_annotation_v2/model/my_exception.dart';
import 'package:mocktail/mocktail.dart';

import '../../util/helper.dart';
import '../../util/provider_container.dart';

class MainUiModelStateNotifierMock extends AutoDisposeNotifier<MainUiModel>
    with Mock
    implements MainUiModelStateNotifier {}

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
  setUp(() {
    repository = RepositoryMock();
    stateNotifier = MainUiModelStateNotifierMock();
    container = createContainer(
      overrides: [
        repositoryProvider.overrideWith((ref) => repository),
        mainUiModelStateNotifierProvider.overrideWith(() => stateNotifier),
      ],
    );
    eventHandler = container.read(mainEventHandlerProvider);
  });
  tg("load success", () {
    tw("load", () {
      tt("setLoaded", () async {
        when(() => repository.load()).thenAnswer((_) async => annotationTask);
        await eventHandler.load();
        verifyInOrder([
          () => repository.load(),
          () => stateNotifier.setLoaded(annotationTask),
        ]);
      });
    });
  });
  tg("load error", () {
    tw("load", () {
      tt("setError", () async {
        const error = MyError.readFile("label.txt");
        when(() => repository.load()).thenThrow(MyException(error));
        await eventHandler.load();
        verifyInOrder([
          () => repository.load(),
          () => stateNotifier.setError(error),
        ]);
      });
    });
  });
  tw("move", () {
    tt("StateNotifier#move is called", () {
      eventHandler.move(1);
      verify(() => stateNotifier.move(1));
    });
  });
  tw("update", () {
    tt("StateNotifier#update is called", () {
      eventHandler.update(1);
      verifyInOrder(
          [() => stateNotifier.update(1), () => stateNotifier.startSave()]);
    });
  });
  tg("save succeed", () {
    tw("save", () {
      tt("onSaveStarted and onSaveFinished", () async {
        when(() => repository.saveResults(images)).thenAnswer((_) async {});
        await eventHandler.save(images);
        verifyInOrder([
          () => stateNotifier.onSaveStarted(),
          () => repository.saveResults(images),
          () => stateNotifier.onSaveFinished(),
        ]);
      });
    });
  });
  tg("save failed", () {
    tw("save", () {
      tt("onSaveStarted, setError and onSaveFinished", () async {
        const error = MyError.writeFile("result.csv");
        when(() => repository.saveResults(images))
            .thenThrow(MyException(error));
        await eventHandler.save(images);
        verifyInOrder([
          () => stateNotifier.onSaveStarted(),
          () => repository.saveResults(images),
          () => stateNotifier.setError(error),
          () => stateNotifier.onSaveFinished(),
        ]);
      });
    });
  });
}
