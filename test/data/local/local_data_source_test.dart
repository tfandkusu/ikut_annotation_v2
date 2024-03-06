import 'package:flutter/cupertino.dart';
import 'package:ikut_annotation_v2/data/local/app_database.dart';

import '../../util/helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  tw("saveLabels", () {
    tt("labels are saved", () {
      final database = AppDatabase();
      database.saveLabels(["takoyaki", "sushi", "gyoza", "other"]);
    });
  });
}
