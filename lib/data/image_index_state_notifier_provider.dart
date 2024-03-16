import 'package:ikut_annotation_v2/model/image_index.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_index_state_notifier_provider.g.dart';

@Riverpod(keepAlive: true)
class ImageIndexStateNotifier extends _$ImageIndexStateNotifier {
  @override
  ImageIndex build() => const ImageIndex(imageIndex: 0, previousImageIndex: 0);

  /// Update selected image
  void move({required int diff, required int imagesLength}) {
    int nextIndex = state.imageIndex + diff;
    if (nextIndex >= imagesLength) {
      nextIndex = imagesLength - 1;
    } else if (nextIndex < 0) {
      nextIndex = 0;
    }
    state = state.copyWith(
        imageIndex: nextIndex, previousImageIndex: state.imageIndex);
  }

  void reset() {
    state = state.copyWith(imageIndex: 0, previousImageIndex: 0);
  }
}
