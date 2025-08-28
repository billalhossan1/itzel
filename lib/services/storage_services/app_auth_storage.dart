import 'package:get_storage/get_storage.dart';

import '../../constants/storage_key.dart';
import '../../utils/app_all_log/error_log.dart';

class AppAuthStorage {
  GetStorage box = GetStorage();

  Future<void> setToken(String value) async {
    try {
      await box.write(StorageKey.token, value);
    } catch (e) {
      errorLog("set token ", e);
    }
  }

  String? getToken() {
    try {
      return box.read(StorageKey.token);
    } catch (e) {
      errorLog("get token", e);
      return null;
    }
  }

  Future<void> storageClear() async {
    try {
      await box.erase();
    } catch (e) {
      errorLog("logout", e);
    }
  }

  Future<void> setRole(String value) async {
    try {
      await box.write(StorageKey.role, value);
    } catch (e) {
      errorLog("set role", e);
    }
  }

  String? getRole() {
    try {
      return box.read(StorageKey.role);
    } catch (e) {
      errorLog("get role", e);
      return null;
    }
  }
}
