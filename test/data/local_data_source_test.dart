import 'package:flutter/cupertino.dart';
import 'package:ikut_annotation_v2/data/local_data_source.dart';

import '../util/helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  tw("saveLabels", () {
    tt("labels are saved", () {
      final database = LocalDataSource();
      database.saveLabels(["takoyaki", "sushi", "gyoza", "other"]);
    });
  });
}
