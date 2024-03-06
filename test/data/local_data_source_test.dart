import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikut_annotation_v2/data/local_data_source.dart';

import '../util/helper.dart';

void main() {
  late LocalDataSource dataSource;
  setUp(() {
    dataSource = LocalDataSource.test(NativeDatabase.memory());
  });
  tw("saveLabels", () {
    tt("labels are saved", () async {
      final labels = ["takoyaki", "sushi", "gyoza", "other"];
      dataSource.saveLabels(labels);
      expect(labels, await dataSource.loadLabels());
    });
  });
}
