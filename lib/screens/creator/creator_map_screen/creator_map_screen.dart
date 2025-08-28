import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreatorMapScreen extends StatefulWidget {
  const CreatorMapScreen({super.key});

  @override
  State<CreatorMapScreen> createState() => _CreatorMapScreenState();
}

class _CreatorMapScreenState extends State<CreatorMapScreen> {
  GoogleMapController? mapController;
  LatLng? selectedLocation;
  String? selectedAddress;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => isLoading = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      selectedLocation = LatLng(position.latitude, position.longitude);
      await _getAddressFromLatLng(selectedLocation!);

      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: selectedLocation!,
              zoom: 15,
            ),
          ),
        );
      }
    } catch (e) {
      print("Error getting location: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        selectedAddress = [
          place.street,
          place.subLocality,
          place.locality,
          place.postalCode,
          place.country,
        ].where((element) => element != null && element.isNotEmpty).join(', ');
        setState(() {});
      }
    } catch (e) {
      print("Error getting address: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        actions: [
          if (selectedLocation != null)
            TextButton(
              onPressed: () {
                Get.back(result: {
                  'coordinates': [
                    selectedLocation!.latitude,
                    selectedLocation!.longitude
                  ],
                  'name': selectedAddress ?? 'Selected Location'
                });
              },
              child: const Text('Confirm'),
            ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: selectedLocation ?? const LatLng(23.8103, 90.4125),
              // Default to Dhaka
              zoom: 15,
            ),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
              if (selectedLocation != null) {
                controller.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: selectedLocation!,
                      zoom: 15,
                    ),
                  ),
                );
              }
            },
            onTap: (LatLng position) async {
              setState(() => selectedLocation = position);
              await _getAddressFromLatLng(position);
            },
            markers: selectedLocation != null
                ? {
                    Marker(
                      markerId: const MarkerId('selected'),
                      position: selectedLocation!,
                      infoWindow: InfoWindow(
                        title: 'Selected Location',
                        snippet: selectedAddress,
                      ),
                    ),
                  }
                : {},
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          if (selectedLocation != null && selectedAddress != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    selectedAddress!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
