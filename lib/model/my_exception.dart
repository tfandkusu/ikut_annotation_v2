import 'my_error.dart';

class MyException implements Exception {
  final MyError myError;
  MyException(this.myError);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyException &&
          runtimeType == other.runtimeType &&
          myError == other.myError;

  @override
  int get hashCode => myError.hashCode;
}
