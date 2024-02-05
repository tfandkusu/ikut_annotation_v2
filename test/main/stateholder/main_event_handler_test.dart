import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikut_annotation_v2/data/repository.dart';
import 'package:ikut_annotation_v2/main/stateholder/main_event_handler.dart';
import 'package:ikut_annotation_v2/main/stateholder/main_ui_model.dart';
import 'package:ikut_annotation_v2/main/stateholder/main_ui_model_state_notifier_provider.dart';
import 'package:ikut_annotation_v2/model/annotation_task.dart';
import 'package:ikut_annotation_v2/model/label_image.dart';
import 'package:mocktail/mocktail.dart';

import '../../util/helper.dart';
import '../../util/provider_container.dart';

class MainUiModelStateNotifierMock extends AutoDisposeNotifier<MainUiModel>
    with Mock
    implements MainUiModelStateNotifier {}

class RepositoryMock extends Mock implements Repository {}

void main() {
  const images = [
    LabeledImage(path: "img/01.png", label: "sushi"),
    LabeledImage(path: "img/02.png", label: "takoyaki"),
    LabeledImage(path: "img/03.png", label: "gyoza"),
    LabeledImage(path: "img/04.png", label: "sushi"),
  ];
  const labels = ["takoyaki", "sushi", "gyoza"];
  const annotationTask = AnnotationTask(labels: labels, results: images);
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
}
