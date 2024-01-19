import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikut_annotation_v2/main/stateholder/main_ui_model.dart';
import 'package:ikut_annotation_v2/main/stateholder/main_ui_model_state_notifier_provider.dart';
import 'package:ikut_annotation_v2/model/label_image.dart';

import '../../util/provider_container.dart';

void main() {
  group("mainUiModelStateNotifier", () {
    const images = [
      LabeledImage(path: "img/01.png", label: "sushi"),
      LabeledImage(path: "img/02.png", label: "takoyaki"),
      LabeledImage(path: "img/03.png", label: "gyoza"),
      LabeledImage(path: "img/04.png", label: "sushi"),
    ];
    const labels = ["takoyaki", "sushi", "gyoza"];
    late ProviderContainer container;
    late MainUiModelStateNotifier stateNotifier;
    setUp(() {
      container = createContainer();
      stateNotifier = container.read(mainUiModelStateNotifierProvider.notifier);
    });
    getState() => container.read(mainUiModelStateNotifierProvider);
    group("when setLoaded", () {
      test("then set images and labels", () {
        expect(
            getState(),
            const MainUiModel(
                images: [],
                imageIndex: 0,
                previousImageIndex: 0,
                labels: [],
                writing: false));
        stateNotifier.setLoaded(
          images,
          labels,
        );
        expect(
            getState(),
            const MainUiModel(
                images: images,
                imageIndex: 0,
                previousImageIndex: 0,
                labels: labels,
                writing: false));
      });
    });
    group("when move", () {
      test("then update imageIndex and previous index", () {
        stateNotifier.setLoaded(
          images,
          labels,
        );
        stateNotifier.move(1);
        expect(
            getState(),
            const MainUiModel(
                images: images,
                imageIndex: 1,
                previousImageIndex: 0,
                labels: labels,
                writing: false));
        stateNotifier.move(2);
        expect(
            getState(),
            const MainUiModel(
                images: images,
                imageIndex: 3,
                previousImageIndex: 1,
                labels: labels,
                writing: false));
      });
    });
    group("when move under zero", () {
      test("then update imageIndex to 0", () {
        stateNotifier.setLoaded(
          images,
          labels,
        );
        stateNotifier.move(-1);
        expect(
            getState(),
            const MainUiModel(
                images: images,
                imageIndex: 0,
                previousImageIndex: 0,
                labels: labels,
                writing: false));
      });
    });
    group("when move over images.count", () {
      test("then update imageIndex to images.count - 1", () {
        stateNotifier.setLoaded(
          images,
          labels,
        );
        stateNotifier.move(4);
        expect(
            getState(),
            const MainUiModel(
                images: images,
                imageIndex: 3,
                previousImageIndex: 0,
                labels: labels,
                writing: false));
      });
    });
  });
}
