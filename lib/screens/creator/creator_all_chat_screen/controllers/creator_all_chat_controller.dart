import 'package:get/get.dart';

import '../../../../models/my_group_model.dart';
import '../../../../services/repository/my_group_repository/my_group_repository.dart';

class CreatorAllChatController extends GetxController {
  final MyGroupRepository _myGroupRepository = MyGroupRepository();
  var creatorGroups = <MyGroup>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserGroups();
  }

  Future<void> fetchUserGroups() async {
    try {
      isLoading.value = true;
      final fetchedGroups = await _myGroupRepository.fetchUserGroups();
      if (fetchedGroups != null) {
        creatorGroups.value = fetchedGroups.data ?? [];
      }
    } catch (e) {
      print('Error fetching user groups: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
