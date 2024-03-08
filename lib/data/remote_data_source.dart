import 'package:dio/dio.dart';
import 'package:ikut_annotation_v2/model/labeled_image.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaml/yaml.dart';

import '../model/annotation_task.dart';

part 'remote_data_source.g.dart';

@riverpod
RemoteDataSource remoteDataSource(RemoteDataSourceRef ref) {
  return RemoteDataSource();
}

class RemoteDataSource {
  final _dio = Dio();

  Future<AnnotationTask> load(String taskUrl) async {
    final response = await _dio.get(taskUrl);
    final yaml = loadYaml(response.data);
    List<String> labels = [];
    List<LabeledImage> images = [];
    for (String label in yaml["labels"]) {
      labels.add(label);
    }
    for (final image in yaml["images"]) {
      images.add(LabeledImage(
        id: 0,
        url: image["url"],
        label: image["label"],
      ));
    }
    return AnnotationTask(labels: labels, images: images);
  }
}
