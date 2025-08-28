import 'package:flutter/material.dart';
import 'package:itzel/screens/creator/creator_payment_method_screen/widgets/creator_payment_method_textfield_widget.dart';
import 'package:itzel/screens/creator/creator_payment_method_screen/widgets/date_picker_widget.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/appbar_widget/appbar_widget.dart';
import '../../../widgets/button_widget/button_widget.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';

class CreatorPaymentMethodScreen extends StatefulWidget {
  const CreatorPaymentMethodScreen({super.key});

  @override
  State<CreatorPaymentMethodScreen> createState() =>
      _CreatorPaymentMethodScreenState();
}

class _CreatorPaymentMethodScreenState
    extends State<CreatorPaymentMethodScreen> {
  final nameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expDateController = TextEditingController();
  final cvvController = TextEditingController();

  DateTime? expiryDate;
  DateTime? cvvDate;

  void setExpiryDate(DateTime date) {
    setState(() {
      expiryDate = date;
    });
  }

  void setCvvDate(DateTime date) {
    setState(() {
      cvvDate = date;
    });
  }

  void updatePaymentMethod() {
    // Implement your payment method update logic here
    print('Updating payment method...');
    print('Name: ${nameController.text}');
    print('Card Number: ${cardNumberController.text}');
    print('Expiry Date: $expiryDate');
    print('CVV: $cvvDate');
  }

  @override
  void dispose() {
    nameController.dispose();
    cardNumberController.dispose();
    expDateController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
        backgroundColor: AppColors.whiteBg,
        appBar: const AppbarWidget(text: 'Payment  Method'),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/debitCardImage.png',
                  height: size.height / (size.height / 215),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SpaceWidget(spaceHeight: 16),
              const TextWidget(
                text: 'Name',
                fontColor: AppColors.grey900,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              const SpaceWidget(spaceHeight: 4),
              CreatorPaymentMethodTextFieldWidget(
                hintText: '',
                controller: nameController,
                maxLines: 1,
              ),
              const SpaceWidget(spaceHeight: 8),
              const TextWidget(
                text: 'Card Number',
                fontColor: AppColors.grey900,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              const SpaceWidget(spaceHeight: 4),
              CreatorPaymentMethodTextFieldWidget(
                hintText: '',
                controller: cardNumberController,
                maxLines: 1,
                keyboardType: TextInputType.number,
              ),
              const SpaceWidget(spaceHeight: 8),
              Row(
                children: [
                  Expanded(
                    child: DatePickerWidget(
                      label: 'Expired Date',
                      onDateSelected: setExpiryDate,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DatePickerWidget(
                      label: 'CVV',
                      onDateSelected: setCvvDate,
                    ),
                  ),
                ],
              ),
              const SpaceWidget(spaceHeight: 40),
              ButtonWidget(
                onPressed: updatePaymentMethod,
                label: 'Update',
                buttonWidth: double.infinity,
              ),
            ],
          ),
        ));
  }
}
