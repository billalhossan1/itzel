import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import '../../../../models/get_event_status_model.dart';
import '../../../../services/repository/event_repository/event_repository.dart';

class EditEventPostController extends GetxController {
  var isLoading = false.obs;
  late EventStatus event;
  final EventRepository _eventRepository = EventRepository();

  // File pickers
  final picker = ImagePicker();
  Rx<File?> image = Rx<File?>(null);
  Rx<File?> videoFile = Rx<File?>(null);
  RxString selectedType = ''.obs;
  String thumbnailImageUrl = '';
  RxString videoUrl = ''.obs;
  // Text controllers
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController eventDescriptionController = TextEditingController();
  final TextEditingController eventTagController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // Pre-fill controllers with event data
  void loadEventData(EventStatus eventStatus) {
    event = eventStatus;
    eventNameController.text = event.name ?? '';
    selectedType.value = event.type?? ''; // You may want to use event.type if available
    timeController.text = event.time.toString();
    thumbnailImageUrl = event.thumbnailImage ?? '';
    print("================================================$thumbnailImageUrl");
    videoUrl.value = event.introMedia ?? '';
    addressController.text = event.address ?? '';
    locationController.text = event.coordinate.join(', ');
    eventDescriptionController.text = event.description ?? '';
    eventTagController.text = event.tags.join(' ');
    priceController.text = event.price.toString();
    image.value = null; // Show existing image by URL, allow picking new
    videoFile.value = null; // Show existing video by URL, allow picking new
  }

  var isPickingImage = false;
  var isPickingVideo = false;

  Future<void> pickImage() async {
    if (isPickingImage) return;
    isPickingImage = true;
    try {
      final XFile? selectedImage = await picker.pickImage(source: ImageSource.gallery);
      if (selectedImage != null) {
        image.value = File(selectedImage.path);
      }
    } catch (e) {
      // Optionally log or handle error
    } finally {
      isPickingImage = false;
    }
  }

  Future<void> pickVideo() async {
    if (isPickingVideo) return;
    isPickingVideo = true;
    try {
      final XFile? selectedVideo = await picker.pickVideo(source: ImageSource.gallery);
      if (selectedVideo != null) {
        videoFile.value = File(selectedVideo.path);
      }
    } catch (e) {
      // Optionally log or handle error
    } finally {
      isPickingVideo = false;
    }
  }

  Future<void> pickDateTime(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: event.time,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(event.time),
      );
      if (selectedTime != null) {
        final DateTime fullDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
        timeController.text = fullDateTime.toString();
      }
    }
  }

  // TODO: Add location picker logic if needed

  Future<void> updateEvent() async {
    isLoading.value = true;
    try {
      // Parse tags
      List<String> tags = eventTagController.text.trim().isEmpty
        ? []
        : eventTagController.text.trim().split(RegExp(r'[ ,]+')).where((tag) => tag.isNotEmpty).toList();
      // Parse coordinates
      List<double> coordinate = locationController.text.trim().isEmpty
        ? []
        : locationController.text.trim().split(',').map((e) => double.tryParse(e.trim()) ?? 0.0).toList();
      // Parse price
      int price = int.tryParse(priceController.text.trim()) ?? 0;
      // Prepare time
      String time = timeController.text.trim();
      // Call repo
      bool success = await _eventRepository.updateEvent(
        eventId: event.id,
        name: eventNameController.text.trim(),
        type: selectedType.value.trim(),
        time: time,
        address: addressController.text.trim(),
        description: eventDescriptionController.text.trim(),
        tags: tags,
        price: price,
        coordinate: coordinate,
        thumbnailImage: image.value,
        introMedia: videoFile.value,
        thumbnailImageUrl: thumbnailImageUrl,
        introMediaUrl: videoUrl.value,
      );
      if (success) {
        Get.back();
        Get.snackbar('Success', 'Event updated successfully');


      } else {
        Get.snackbar('Error', 'Failed to update event');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while updating event');
    } finally {
      isLoading.value = false;
    }
  }
}
