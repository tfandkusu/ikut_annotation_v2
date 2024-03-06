import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import '../model/annotation_task.dart';
import '../model/labeled_image.dart';

part 'local_data_source.g.dart';

class LocalLabels extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();
}

class LocalImages extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get url => text()();

  IntColumn get labelId =>
      integer().customConstraint('NOT NULL REFERENCES local_labels(id)')();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(join(dbFolder.path, 'app.sqlite3'));
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }
    final cacheBase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cacheBase;
    return NativeDatabase.createInBackground(file);
  });
}

@DriftDatabase(tables: [LocalImages, LocalLabels])
class LocalDataSource extends _$LocalDataSource {
  LocalDataSource() : super(_openConnection());

  LocalDataSource.test(NativeDatabase db) : super(db);

  @override
  int get schemaVersion => 1;

  Future<void> saveAnnotationTask(AnnotationTask task) {
    return transaction(() async {
      delete(localImages);
      delete(localLabels);
      for (final label in task.labels) {
        into(localLabels).insert(LocalLabelsCompanion.insert(name: label));
      }
      final savedLabels = await select(localLabels).get();
      Map<String, int> idMap = {
        for (var label in savedLabels) label.name: label.id
      };
      for (final image in task.images) {
        into(localImages).insert(LocalImagesCompanion.insert(
          url: image.url,
          labelId: idMap[image.label]!,
        ));
      }
    });
  }

  Stream<List<String>> watchLabels() {
    return (select(localLabels)
          ..orderBy([(t) => OrderingTerm(expression: t.id)]))
        .watch()
        .map((rows) => rows.map((row) => row.name).toList());
  }

  Stream<List<LabeledImage>> watchImages() {
    return select(localImages)
        .join([
          innerJoin(localLabels, localLabels.id.equalsExp(localImages.labelId))
        ])
        .watch()
        .map((rows) => rows
            .map((row) => LabeledImage(
                  id: row.readTable(localImages).id,
                  url: row.readTable(localImages).url,
                  label: row.readTable(localLabels).name,
                ))
            .toList());
  }

  Future<void> updateImageLabel(int imageId, int labelIndex) async {
    final labels = await (select(localLabels)
          ..orderBy([(t) => OrderingTerm(expression: t.id)]))
        .get();
    final labelId = labels[labelIndex].id;
    await (update(localImages)..where((t) => t.id.equals(imageId)))
        .write(LocalImagesCompanion(
      labelId: Value(labelId),
    ));
  }
}
