import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

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

  Future<void> saveLabels(List<String> labels) {
    return transaction(() async {
      for (final label in labels) {
        into(localLabels).insert(LocalLabelsCompanion.insert(name: label));
      }
    });
  }

  Future<List<String>> loadLabels() {
    return select(localLabels)
        .get()
        .then((rows) => rows.map((row) => row.name).toList());
  }
}
