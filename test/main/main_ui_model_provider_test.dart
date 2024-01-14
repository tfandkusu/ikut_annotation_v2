import 'package:flutter_test/flutter_test.dart';
import 'package:ikut_annotation_v2/main/main_ui_model.dart';
import 'package:ikut_annotation_v2/main/main_ui_model_provider.dart';
import 'package:ikut_annotation_v2/model/label_image.dart';

import '../provider_container.dart';

void main() {
  test('mainUiModelProvider', () {
    final container = createContainer();
    final mainUiModel = container.read(mainUiModelProvider);
    expect(
        mainUiModel,
        const MainUiModel(
            images: [
              LabeledImage(path: "image_01.png", label: "sushi"),
            ],
            imageIndex: 0,
            previousImageIndex: 0,
            labels: ["takoyaki", "sushi", "gyoza"]));
  });
}
