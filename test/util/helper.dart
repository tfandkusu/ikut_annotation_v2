import 'package:flutter_test/flutter_test.dart';

void given(String description, Function() body) {
  group("Given $description", body);
}

void when(String description, Function() body) {
  group("When $description", body);
}

void then(String description, Function() body) {
  test("Then $description", body);
}
