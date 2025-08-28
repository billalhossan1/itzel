import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../widgets/appbar_widget/appbar_widget.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_field_widget/text_field_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';

class CreatorDeleteAccountScreen extends StatefulWidget {
  const CreatorDeleteAccountScreen({super.key});

  @override
  State<CreatorDeleteAccountScreen> createState() =>
      _CreatorDeleteAccountScreenState();
}

class _CreatorDeleteAccountScreenState
    extends State<CreatorDeleteAccountScreen> {
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;

  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  void deleteAccount() {
    final password = passwordController.text;
    if (password.isEmpty) {
      showError("Enter Password");
    } else if (password.length < 6) {
      showError("Password length should be more than 6 characters");
    } else {
      // Add your delete account logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account deleted successfully')),
      );
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
