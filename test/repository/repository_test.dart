import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikut_annotation_v2/data/repository.dart';
import 'package:ikut_annotation_v2/model/label_image.dart';

import '../util/helper.dart';
import '../util/provider_container.dart';

void main() {
  late ProviderContainer container;
  late Repository repository;
  setUp(() {
    container = createContainer();
    repository = container.read(repositoryProvider);
  });
  when("loadLabels", () {
    then("return labels", () async {
      final labels = await repository.loadLabels();
      expect(labels, ["takoyaki", "sushi", "gyoza", "other"]);
    });
  });
  when("loadResults", () {
    then("return list of LabelImage", () async {
      final dir = Directory.current.path.toString();
      final results =
          await repository.loadResults(["takoyaki", "sushi", "gyoza", "other"]);
      expect(results.length, 300);
      expect(results[0],
          LabeledImage(path: "$dir/image/1002013.jpg", label: "takoyaki"));
      expect(results[4],
          LabeledImage(path: "$dir/image/100332.jpg", label: "sushi"));
      expect(results[299],
          LabeledImage(path: "$dir/image/1399892.jpg", label: "takoyaki"));
    });
  });
}
