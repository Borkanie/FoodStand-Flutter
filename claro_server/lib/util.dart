import 'dart:io';

class Util {
  static const String defaultDBBPath = "D:\\Development\\DBB";

  static Future<File> getEmptyFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
    await file.create();
    return Future(() => file);
  }
}