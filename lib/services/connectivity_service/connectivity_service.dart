import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService extends GetxService {
  List<ConnectivityResult> connectionStatus = [];
  final Connectivity connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    connectionStatus = [];
    connectionStatus = result;
    log('Connectivity changed: $connectionStatus');
  }

  Future<void> onInitialFunction() async {
    try {
      initConnectivity();
      connectivitySubscription = connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    } catch (e) {
      log("Error message $e");
    }
  }

  onCloseFunction() {
    try {
      connectivitySubscription.cancel();
    } catch (e) {
      log("Error message $e");
    }
  }

  @override
  void onInit() {
    onInitialFunction();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    onCloseFunction();
  }
}


//   final Connectivity _connectivity = Connectivity();
//   var isConnected = true.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     _connectivity.onConnectivityChanged.listen((event) {
//       _updateConnectionStatus();
//     },);
//     _checkInitialConnection();
//   }

//   Future<void> _checkInitialConnection() async {
//     ConnectivityResult result = await _connectivity.checkConnectivity();
//     _updateConnectionStatus(result);
//   }

//   void _updateConnectionStatus(ConnectivityResult result) {
//     if (result == ConnectivityResult.none) {
//       isConnected.value = false;
//       Get.toNamed('/error');
//     } else {
//       isConnected.value = true;
//     }
//   }
// }
