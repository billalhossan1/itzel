import 'package:get/get.dart';
import 'package:itzel/services/storage_services/app_auth_storage.dart';

import '../../../../models/my_group_model.dart';
import '../../../../services/repository/my_group_repository/my_group_repository.dart';

class UserAllChatController extends GetxController {
  final MyGroupRepository _myGroupRepository = MyGroupRepository();
  var userGroups = <MyGroup>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    String? token=AppAuthStorage().getToken();
    if(token!=null && token.isNotEmpty==true){
      fetchUserGroups();
    }
    //fetchUserGroups();
  }

  Future<void> fetchUserGroups() async {
    try {
      isLoading.value = true;
      final fetchedGroups = await _myGroupRepository.fetchUserGroups();
      if (fetchedGroups != null) {
        userGroups.value = fetchedGroups.data ?? [];
      }
    } catch (e) {
      print('Error fetching user groups: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
