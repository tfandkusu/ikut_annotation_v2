import 'package:freezed_annotation/freezed_annotation.dart';
part 'my_error.freezed.dart';

@freezed
sealed class MyError with _$MyError {
  const factory MyError.readFile(String path) = ReadFile;
}
