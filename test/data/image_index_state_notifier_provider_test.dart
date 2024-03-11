import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikut_annotation_v2/data/image_index_state_notifier_provider.dart';
import 'package:ikut_annotation_v2/model/image_index.dart';

import '../util/helper.dart';
import '../util/provider_container.dart';

void main() {
  late ProviderContainer container;
  late ImageIndexStateNotifier stateNotifier;
  setUp(() {
    container = createContainer();
    stateNotifier = container.read(imageIndexStateNotifierProvider.notifier);
  });
  getState() => container.read(imageIndexStateNotifierProvider);

  tw("move", () {
    tt("update imageIndex and previous index", () {
      stateNotifier.move(diff: 1, imagesLength: 3);
      expect(
          getState(), const ImageIndex(imageIndex: 1, previousImageIndex: 0));
      stateNotifier.move(diff: 2, imagesLength: 5);
      expect(
          getState(),
          const ImageIndex(
            imageIndex: 3,
            previousImageIndex: 1,
          ));
    });
  });
  tw("move under zero", () {
    tt("update imageIndex to 0", () {
      stateNotifier.move(diff: -1, imagesLength: 3);
      expect(
          getState(),
          const ImageIndex(
            imageIndex: 0,
            previousImageIndex: 0,
          ));
    });
  });
  tw("move over images.count", () {
    tt("update imageIndex to images.count - 1", () {
      stateNotifier.move(diff: 3, imagesLength: 3);
      expect(
          getState(),
          const ImageIndex(
            imageIndex: 2,
            previousImageIndex: 0,
          ));
    });
  });
}
