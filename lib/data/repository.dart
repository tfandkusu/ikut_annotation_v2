import 'dart:io';

import 'package:csv/csv.dart';
import 'package:ikut_annotation_v2/model/label_image.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository.g.dart';

@riverpod
Repository repository(RepositoryRef ref) {
  return Repository();
}

class Repository {
  Future<List<String>> loadLabels() async {
    final dir = Directory.current.path;
    final file = File('$dir/label.txt');
    final csvString = await file.readAsString();
    final fields = const CsvToListConverter(
      eol: '\n',
    ).convert(csvString);
    final labels = fields.map((items) => items[0] as String).toList();
    return labels;
  }

  Future<List<LabeledImage>> loadResults(List<String> labels) async {
    final dir = Directory.current.path;
    final file = File('$dir/result.csv');
    final csvString = await file.readAsString();
    final fields = const CsvToListConverter(
      eol: '\n',
    ).convert(csvString);
    return fields.map((items) {
      final path = "$dir/image/${items[0]}";
      // If labels is not set, first label is used as image's label.
      String label = labels[0];
      if (items.length >= 2) {
        label = items[1];
      }
      return LabeledImage(path: path, label: label);
    }).toList();
  }
}
