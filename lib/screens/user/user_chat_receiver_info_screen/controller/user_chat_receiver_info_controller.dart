import 'package:get/get.dart';

import '../../../../constants/app_images_path.dart';

class UserChatReceiverInfoController extends GetxController {
  // List of media items for the grid view
  final List<String> infoMedia = [
    AppImagesPath.infoMedia1,
    AppImagesPath.infoMedia2,
    AppImagesPath.infoMedia3,
    AppImagesPath.infoMedia4,
    AppImagesPath.infoMedia5,
    AppImagesPath.infoMedia1,
    AppImagesPath.infoMedia2,
    AppImagesPath.infoMedia3,
    AppImagesPath.infoMedia4,
    AppImagesPath.infoMedia5,
  ];

  // Example method to handle an action
  void onMoreTap() {
    print("More icon tapped!");
  }
  @override
  void onClose() {
    // Dispose resources if any
    super.onClose();
  }
}
