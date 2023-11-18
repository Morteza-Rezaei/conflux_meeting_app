import 'dart:math';

class Utils {
  static String generatePassword() {
    const allowedChars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    const passwordLength = 4;
    final random = Random(DateTime.now().millisecondsSinceEpoch);
    final password = List.generate(passwordLength, (index) {
      int randIndex = random.nextInt(allowedChars.length);
      return allowedChars[randIndex];
    }).join();
    return password;
  }
}
