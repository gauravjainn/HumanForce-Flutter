import 'package:hive/hive.dart';

class DbRepository {
  void putData(String boxName, String key, dynamic value) {
    Hive.box(boxName).put(key, value);
  }

  void removeData(String boxName, String key) {
    Hive.box(boxName).delete(key);
  }
}
