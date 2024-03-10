import 'package:ikut_annotation_v2/data/local_data_source.dart';
import 'package:ikut_annotation_v2/data/remote_data_source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yaml_writer/yaml_writer.dart';

import '../model/annotation_task.dart';
import 'local_data_source_provider.dart';

part 'repository.g.dart';

@Riverpod(keepAlive: true)
Repository repository(RepositoryRef ref) {
  return Repository(
      ref.read(remoteDataSourceProvider), ref.read(localDataSourceProvider));
}

class Repository {
  final RemoteDataSource _remoteDataSource;

  final LocalDataSource _localDataSource;

  Repository(this._remoteDataSource, this._localDataSource);

  Future<void> load() async {
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
}
