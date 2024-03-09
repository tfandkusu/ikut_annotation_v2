import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'local_data_source.dart';
part 'local_data_source_provider.g.dart';

@Riverpod(keepAlive: true)
LocalDataSource localDataSource(LocalDataSourceRef ref) {
  return LocalDataSource();
}
