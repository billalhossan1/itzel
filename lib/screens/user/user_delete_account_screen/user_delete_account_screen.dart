import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itzel/routes/app_routes.dart';
import 'package:itzel/services/api/api_delete_services.dart';

import '../../../constants/app_api_url.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../widgets/appbar_widget/appbar_widget.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_field_widget/text_field_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';

class UserDeleteAccountScreen extends StatefulWidget {
  const UserDeleteAccountScreen({super.key});

  @override
  State<UserDeleteAccountScreen> createState() =>
      _UserDeleteAccountScreenState();
}

class _UserDeleteAccountScreenState extends State<UserDeleteAccountScreen> {
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;

  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  Future<void> deleteAccount() async {
    final password = passwordController.text;
    if (password.isEmpty) {
      showError("Enter Password");
    } else if (password.length < 6) {
      showError("Password length should be more than 6 characters");
    } else {
      final response = await ApiDeleteServices().apiDeleteServices(
        '${AppApiUrl.baseUrl}/user',
        statusCode: 200,
      );
      // Add your delete account logic here

      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account deleted successfully')),
        );

        Get.toNamed(AppRoutes.loginScreen);
      }
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: AppColors.whiteBg,
      appBar: const AppbarWidget(text: AppStrings.deleteAccount),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            const TextWidget(
              text: AppStrings.deleteAccountText,
              fontColor: AppColors.blackDarker,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              textAlignment: TextAlign.left,
            ),
            const SpaceWidget(spaceHeight: 30),
            TextFieldWidget(
              hintText: 'Current Password',
              controller: passwordController,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Enter Password";
                } else if (passwordController.text.length < 6) {
                  return "Password length should be more than 6 characters";
                }
                return null;
              },
              maxLines: 1,
              suffixIcon: Icons.visibility_off_outlined,
            ),
            const SpaceWidget(spaceHeight: 48),
            const TextWidget(
              text: AppStrings.deleteAccountConfirmationText,
              fontColor: AppColors.blackLight2,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            const SpaceWidget(spaceHeight: 16),
            Container(
              height: (size.height / (size.height / 54)),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.red,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 5.0,
                  ),
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              child: MaterialButton(
                onPressed: deleteAccount,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                child: Text(
                  "Delete Account",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: (size.width / (size.width / 16)),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
