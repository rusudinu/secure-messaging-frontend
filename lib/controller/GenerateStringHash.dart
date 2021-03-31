import 'dart:math';

class GenerateRoomID {
  static String generateStringHash(int len) {
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    var r = Random();
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }
}
