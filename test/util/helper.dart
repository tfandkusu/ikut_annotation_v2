import 'package:flutter_test/flutter_test.dart';

void tg(String description, Function() body) {
  group("Given $description", body);
}

void tw(String description, Function() body) {
  group("When $description", body);
}

void tt(String description, Function() body) {
  test("Then $description", body);
}
