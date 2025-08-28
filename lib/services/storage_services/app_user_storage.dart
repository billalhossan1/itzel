import 'package:get_storage/get_storage.dart';

import '../../constants/storage_key.dart';
import '../../utils/app_all_log/error_log.dart';

class AppUserStorage {
  ////////////// storage initial
  GetStorage box = GetStorage();

  Future<void> setUserData(dynamic value) async {
    try {
      await box.write(StorageKey.userData, value);
    } catch (e) {
      errorLog("user data not set", e);
    }
  }

  getUserRowData() {
    try {
      return box.read(StorageKey.userData);
    } catch (e) {
      return null;
    }
  }
}
