import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

class LocationController extends GetxController {
  final loc.Location _location = loc.Location();
  Rx<LatLng?> currentLocation = Rx<LatLng?>(null);
  RxString currentAddress = RxString('Fetching current address...');
  RxString destinationAddress = RxString('Fetching destination address...');
  LatLng? destinationLocation;
  RxBool isLoadingDestination = false.obs;

  Future<void> initializeDestination(LatLng destination) async {
    isLoadingDestination.value = true;
    destinationLocation = destination;
    await getDestinationAddress(destination);
    isLoadingDestination.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    getLocationUpdates();
  }

  Future<void> getLocationUpdates() async {
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;

    try {
      serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          print('Location services are disabled.');
          return;
        }
      }

      permissionGranted = await _location.hasPermission();
      if (permissionGranted == loc.PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != loc.PermissionStatus.granted) {
          print('Location permissions are denied.');
          return;
        }
      }

      _location.onLocationChanged.listen((loc.LocationData locationData) {
        if (locationData.latitude != null && locationData.longitude != null) {
          currentLocation.value =
              LatLng(locationData.latitude!, locationData.longitude!);
          print('Current Location: $currentLocation');
          getAddressFromLatLng(currentLocation.value!);
        }
      });
    } catch (e) {
      print('Error in getLocationUpdates: $e');
    }
  }

  Future<void> getAddressFromLatLng(LatLng position) async {
    try {
      print(
          'Fetching address for coordinates: ${position.latitude}, ${position.longitude}');
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        currentAddress.value =
            '${place.street}, ${place.locality}, ${place.country}';
        print('Current address updated: ${currentAddress.value}');
      } else {
        currentAddress.value = 'Address not found';
        print('No address found for the current location.');
      }
    } catch (e) {
      currentAddress.value = 'Error fetching address';
      print('Error getting current address: $e');
    }
  }

  Future<void> getDestinationAddress(LatLng destination) async {
    try {
      print(
          'Fetching address for destination: ${destination.latitude}, ${destination.longitude}');
      List<Placemark> placemarks = await placemarkFromCoordinates(
        destination.latitude,
        destination.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        destinationAddress.value =
            '${place.street}, ${place.locality}, ${place.country}';
        print('Destination address updated: ${destinationAddress.value}');
      } else {
        destinationAddress.value = 'Destination address not found';
        print('No address found for the destination.');
      }
    } catch (e) {
      destinationAddress.value = 'Error fetching destination address';
      print('Error getting destination address: $e');
    }
  }
}
