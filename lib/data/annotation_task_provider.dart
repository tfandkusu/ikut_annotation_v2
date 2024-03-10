import 'package:ikut_annotation_v2/data/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/annotation_task.dart';
part 'annotation_task_provider.g.dart';

@riverpod
Stream<AnnotationTask> annotationTaskStream(AnnotationTaskStreamRef ref) {
  final repository = ref.read(repositoryProvider);
  return repository.watchAnnotationTask();
}

@riverpod
Future<AnnotationTask> annotationTaskFuture(AnnotationTaskFutureRef ref) async {
  return ref.watch(annotationTaskStreamProvider.future);
}
