import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikut_annotation_v2/data/repository.dart';
import 'package:ikut_annotation_v2/model/labeled_image.dart';
import 'package:ikut_annotation_v2/model/my_error.dart';
import 'package:ikut_annotation_v2/model/my_exception.dart';

import '../util/helper.dart';
import '../util/provider_container.dart';

void main() {
  late ProviderContainer container;
  late Repository repository;
  setUp(() {
    container = createContainer();
    repository = container.read(repositoryProvider);
  });
  tg("File exists", () {
    tw("load", () {
      tt("It returns labels", () async {
        final dir = Directory.current.path.toString();
        final task = await repository.load();
        expect(task.labels, ["takoyaki", "sushi", "gyoza", "other"]);
        expect(task.images.length, 300);
        expect(
            task.images[0],
            LabeledImage(
                id: 1, url: "$dir/image/1002013.jpg", label: "takoyaki"));
        expect(task.images[4],
            LabeledImage(id: 5, url: "$dir/image/100332.jpg", label: "sushi"));
        expect(
            task.images[299],
            LabeledImage(
                id: 300, url: "$dir/image/1399892.jpg", label: "takoyaki"));
      });
    });
    tw("saveResults", () {
      tt("Result file is saved", () async {
        const testResultFileName = "result_test.csv";
        final task = await repository.load();
        final images = task.images;
        await repository.saveResults(images,
            resultFileName: testResultFileName);
        final savedTask =
            await repository.load(resultFileName: testResultFileName);
        expect(savedTask.images[0], task.images[0]);
        final dir = Directory.current.path.toString();
        await File("$dir/$testResultFileName").delete();
      });
    });
  });
  tg("Label file does not exists", () {
    tw("load", () {
      tt("IOException", () async {
        try {
          await repository.load(labelFileName: "notExist.txt");
          fail("It should throw error");
        } catch (e) {
          expect(e, MyException(const MyError.readFile("notExist.txt")));
        }
      });
    });
  });
  tg("result file does not exists", () {
    tw("load", () {
      tt("IOException", () async {
        try {
          await repository.load(resultFileName: "notExist.txt");
          fail("It should throw error");
        } catch (e) {
          expect(e, MyException(const MyError.readFile("notExist.txt")));
        }
      });
    });
  });
}
