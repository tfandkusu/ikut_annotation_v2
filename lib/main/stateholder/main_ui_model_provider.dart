import 'package:ikut_annotation_v2/main/stateholder/main_ui_model.dart';
import 'package:ikut_annotation_v2/model/label_image.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_ui_model_provider.g.dart';

@riverpod
MainUiModel mainUiModel(MainUiModelRef ref) {
  return const MainUiModel(
      images: [
        LabeledImage(path: "image_01.png", label: "sushi"),
      ],
      imageIndex: 0,
      previousImageIndex: 0,
      labels: ["takoyaki", "sushi", "gyoza"],
      writing: false);
}
