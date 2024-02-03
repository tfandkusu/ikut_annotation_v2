import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikut_annotation_v2/data/repository.dart';
import 'package:ikut_annotation_v2/model/label_image.dart';
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
  given("File exists", () {
    when("load", () {
      then("It returns labels", () async {
        final dir = Directory.current.path.toString();
        final task = await repository.load();
        expect(task.labels, ["takoyaki", "sushi", "gyoza", "other"]);
        expect(task.results.length, 300);
        expect(task.results[0],
            LabeledImage(path: "$dir/image/1002013.jpg", label: "takoyaki"));
        expect(task.results[4],
            LabeledImage(path: "$dir/image/100332.jpg", label: "sushi"));
        expect(task.results[299],
            LabeledImage(path: "$dir/image/1399892.jpg", label: "takoyaki"));
      });
    });
    when("saveResults", () {
      then("Result file is saved", () async {
        const testResultFileName = "result_test.csv";
        final task = await repository.load();
        final results = task.results;
        await repository.saveResults(results,
            resultFileName: testResultFileName);
        final savedTask =
            await repository.load(resultFileName: testResultFileName);
        expect(savedTask.results[0], task.results[0]);
        final dir = Directory.current.path.toString();
        await File("$dir/$testResultFileName").delete();
      });
    });
  });
  given("Label file does not exists", () {
    when("load", () {
      then("IOException", () async {
        try {
          await repository.load(labelFileName: "notExist.txt");
          fail("It should throw error");
        } catch (e) {
          expect(e, MyException(const MyError.readFile("notExist.txt")));
        }
      });
    });
  });
  given("result file does not exists", () {
    when("load", () {
      then("IOException", () async {
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
