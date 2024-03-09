import 'dart:io';

import 'package:collection/collection.dart';
import 'package:csv/csv.dart';
import 'package:ikut_annotation_v2/data/local_data_source.dart';
import 'package:ikut_annotation_v2/data/remote_data_source.dart';
import 'package:ikut_annotation_v2/model/labeled_image.dart';
import 'package:ikut_annotation_v2/model/my_error.dart';
import 'package:ikut_annotation_v2/model/my_exception.dart';
import 'package:path/path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yaml_writer/yaml_writer.dart';

import '../model/annotation_task.dart';
import 'local_data_source_provider.dart';

part 'repository.g.dart';

@riverpod
Repository repository(RepositoryRef ref) {
  return Repository(
      ref.read(remoteDataSourceProvider), ref.read(localDataSourceProvider));
}

class Repository {
  final RemoteDataSource _remoteDataSource;

  final LocalDataSource _localDataSource;

  Repository(this._remoteDataSource, this._localDataSource);

  static const String labelFileName = 'label.txt';

  static const String resultFileName = 'result.csv';

  Future<void> loadV2() async {
    final task = await _remoteDataSource
        .load("https://ikut-annotation-sample.web.app/task.yaml");
    await _localDataSource.saveAnnotationTask(task);
  }

  Stream<AnnotationTask> watchAnnotationTask() {
    return Rx.combineLatest2(
        _localDataSource.watchLabels(), _localDataSource.watchImages(),
        (labels, images) {
      return AnnotationTask(labels: labels, images: images);
    });
  }

  Future<void> updateImageLabel(
      {required int imageId, required int labelIndex}) async {
    await _localDataSource.updateImageLabel(
        imageId: imageId, labelIndex: labelIndex);
  }

  Future<String> getYaml() async {
    final labels = await _localDataSource.watchLabels().first;
    final images = await _localDataSource.watchImages().first;
    Map<String, dynamic> task = {
      "labels": labels,
      "images": images.map((image) {
        return {
          "url": image.url,
          "label": image.label,
        };
      }).toList()
    };
    final yamlWriter = YamlWriter();
    return yamlWriter.write(task);
  }

  Future<AnnotationTask> load(
      {String labelFileName = labelFileName,
      String resultFileName = resultFileName}) async {
    var labels = <String>[];
    try {
      labels = await _loadLabels(fileName: labelFileName);
    } on IOException {
      throw MyException(MyError.readFile(labelFileName));
    }
    try {
      final results = await _loadResults(labels, fileName: resultFileName);
      return AnnotationTask(labels: labels, images: results);
    } on IOException {
      throw MyException(MyError.readFile(resultFileName));
    }
  }

  Future<void> saveResults(List<LabeledImage> results,
      {String resultFileName = resultFileName}) async {
    try {
      final csvString = const ListToCsvConverter().convert(results.map((image) {
        final name = basename(image.url);
        return [name, image.label];
      }).toList());
      final dir = Directory.current.path;
      final file = File('$dir/$resultFileName');
      file.writeAsString(csvString.replaceAll("\r\n", "\n"));
    } on IOException {
      throw MyException(MyError.writeFile(resultFileName));
    }
  }

  Future<List<String>> _loadLabels({String fileName = labelFileName}) async {
    final dir = Directory.current.path;
    final file = File('$dir/$fileName');
    final csvString = await file.readAsString();
    final fields = const CsvToListConverter(
      eol: '\n',
    ).convert(csvString);
    final labels = fields.map((items) => items[0] as String).toList();
    return labels;
  }

  Future<List<LabeledImage>> _loadResults(List<String> labels,
      {String fileName = resultFileName}) async {
    final dir = Directory.current.path;
    final file = File('$dir/$fileName');
    final csvString = await file.readAsString();
    final fields = const CsvToListConverter(
      eol: '\n',
    ).convert(csvString);
    return fields.mapIndexed((index, items) {
      final path = "$dir/image/${items[0]}";
      // If labels is not set, first label is used as image's label.
      String label = labels[0];
      if (items.length >= 2) {
        label = items[1];
      }
      return LabeledImage(id: index + 1, url: path, label: label);
    }).toList();
  }
}
