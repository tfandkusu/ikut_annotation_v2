import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikut_annotation_v2/data/local_data_source.dart';
import 'package:ikut_annotation_v2/data/local_data_source_provider.dart';
import 'package:ikut_annotation_v2/data/remote_data_source.dart';
import 'package:ikut_annotation_v2/data/repository.dart';
import 'package:ikut_annotation_v2/model/annotation_task.dart';
import 'package:ikut_annotation_v2/model/labeled_image.dart';
import 'package:mocktail/mocktail.dart';

import '../util/helper.dart';
import '../util/provider_container.dart';

class RemoteDataSourceMock extends Mock implements RemoteDataSource {}

class LocalDataSourceMock extends Mock implements LocalDataSource {}

void main() {
  late ProviderContainer container;
  late Repository repository;
  late RemoteDataSourceMock remoteDataSource;
  late LocalDataSourceMock localDataSource;
  setUp(() {
    remoteDataSource = RemoteDataSourceMock();
    localDataSource = LocalDataSourceMock();
    container = createContainer(
      overrides: [
        remoteDataSourceProvider.overrideWith((ref) => remoteDataSource),
        localDataSourceProvider.overrideWith((ref) => localDataSource),
      ],
    );
    repository = container.read(repositoryProvider);
  });
  tw("loadV2", () {
    tt("load and save", () async {
      const taskUrl = "https://ikut-annotation-sample.web.app/task.yaml";
      final labels = ["takoyaki", "sushi", "gyoza", "other"];
      final images = [
        const LabeledImage(
            id: 1,
            url: "https://ikut-annotation-sample.web.app/image/1002013.jpg",
            label: "sushi"),
        const LabeledImage(
            id: 2,
            url: "https://ikut-annotation-sample.web.app/image/1002167.jpg",
            label: "takoyaki"),
        const LabeledImage(
            id: 3,
            url: "https://ikut-annotation-sample.web.app/image/1002237.jpg",
            label: "gyoza"),
        const LabeledImage(
            id: 4,
            url: "https://ikut-annotation-sample.web.app/image/1003289.jpg",
            label: "sushi"),
      ];
      final task = AnnotationTask(labels: labels, images: images);
      when(() => remoteDataSource.load(taskUrl)).thenAnswer((_) async => task);
      when(() => localDataSource.saveAnnotationTask(task))
          .thenAnswer((_) async {});
      await repository.load();
      verifyInOrder([
        () => remoteDataSource.load(taskUrl),
        () => localDataSource.saveAnnotationTask(task),
      ]);
    });
  });
  tw("watchAnnotationTask", () {
    tt("get stream of AnnotationTask", () async {
      final labels = ["takoyaki", "sushi", "gyoza", "other"];
      final images = [
        const LabeledImage(
            id: 1,
            url: "https://ikut-annotation-sample.web.app/image/1002013.jpg",
            label: "sushi"),
        const LabeledImage(
            id: 2,
            url: "https://ikut-annotation-sample.web.app/image/1002167.jpg",
            label: "takoyaki"),
        const LabeledImage(
            id: 3,
            url: "https://ikut-annotation-sample.web.app/image/1002237.jpg",
            label: "gyoza"),
        const LabeledImage(
            id: 4,
            url: "https://ikut-annotation-sample.web.app/image/1003289.jpg",
            label: "sushi"),
      ];
      final annotationTask = AnnotationTask(labels: labels, images: images);
      when(() => localDataSource.watchLabels())
          .thenAnswer((_) => Stream.value(labels));
      when(() => localDataSource.watchImages())
          .thenAnswer((_) => Stream.value(images));
      expect(annotationTask, await repository.watchAnnotationTask().first);
    });
  });
  tw("updateImageLabel", () {
    tt("update label of image", () async {
      when(() => localDataSource.updateImageLabel(imageId: 1, labelIndex: 2))
          .thenAnswer((_) async {});
      await repository.updateImageLabel(imageId: 1, labelIndex: 2);
      verify(() => localDataSource.updateImageLabel(imageId: 1, labelIndex: 2));
    });
  });
  tw("getYaml", () {
    tt("get yaml string", () async {
      final labels = ["takoyaki", "sushi", "gyoza", "other"];
      final images = [
        const LabeledImage(
            id: 1,
            url: "https://ikut-annotation-sample.web.app/image/1002013.jpg",
            label: "sushi"),
        const LabeledImage(
            id: 2,
            url: "https://ikut-annotation-sample.web.app/image/1002167.jpg",
            label: "takoyaki"),
        const LabeledImage(
            id: 3,
            url: "https://ikut-annotation-sample.web.app/image/1002237.jpg",
            label: "gyoza"),
      ];
      when(() => localDataSource.watchLabels())
          .thenAnswer((_) => Stream.value(labels));
      when(() => localDataSource.watchImages())
          .thenAnswer((_) => Stream.value(images));
      final yaml = await repository.getYaml();
      const answer = """
labels: 
  - 'takoyaki'
  - 'sushi'
  - 'gyoza'
  - 'other'
images: 
  - url: 'https://ikut-annotation-sample.web.app/image/1002013.jpg'
    label: 'sushi'
  - url: 'https://ikut-annotation-sample.web.app/image/1002167.jpg'
    label: 'takoyaki'
  - url: 'https://ikut-annotation-sample.web.app/image/1002237.jpg'
    label: 'gyoza'
""";
      expect(answer, yaml);
    });
  });
}
