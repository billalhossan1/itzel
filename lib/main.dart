import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get_storage/get_storage.dart';
import 'package:itzel/constants/app_strings.dart';

import 'main_app_entry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await GetStorage.init();

  Stripe.publishableKey = AppStrings.stripePublishableKey;
  await Stripe.instance.applySettings();

  runApp(const MainApp());
}
