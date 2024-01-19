import 'package:flutter_test/flutter_test.dart';
import 'package:ikut_annotation_v2/main/stateholder/main_ui_model.dart';
import 'package:ikut_annotation_v2/main/stateholder/main_ui_model_provider.dart';

import '../../util/provider_container.dart';

void main() {
  test("mainUiModelProvider", () {
    final container = createContainer();
    final mainUiModel = container.read(mainUiModelProvider);
    expect(
        mainUiModel,
        const MainUiModel(
            images: [],
            imageIndex: 0,
            previousImageIndex: 0,
            labels: [],
            writing: false));
  });
}
