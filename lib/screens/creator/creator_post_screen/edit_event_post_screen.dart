import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itzel/constants/app_api_url.dart';
import '../../../models/get_event_status_model.dart';
import 'controllers/edit_event_post_controller.dart';
import '../../../widgets/button_widget/button_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';
import '../../../constants/app_colors.dart';

class EditEventPostScreen extends StatelessWidget {
  final EditEventPostController controller = Get.put(EditEventPostController());

  @override
  Widget build(BuildContext context) {
    final event = Get.arguments as EventStatus;
    controller.loadEventData(event);
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Event')),
      body: Obx(() => SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextWidget(text: 'Edit Thumbnail', fontColor: AppColors.black500, fontSize: 16, fontWeight: FontWeight.w400),
                  const SizedBox(height: 4),
                  DottedBorder(
                    child: InkWell(
                      onTap: controller.pickImage,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          height: size.height / (size.height / 143),
                          width: double.infinity,
                          child: Obx(() {
                            String imageUrl = event.thumbnailImage.startsWith('/')
                              ? AppApiUrl.localDomain + event.thumbnailImage
                              : AppApiUrl.localDomain + '/' + event.thumbnailImage;
                            if(controller.thumbnailImageUrl.isEmpty){
                              return Image.network(imageUrl, fit: BoxFit.cover);
                            }else if (controller.image.value != null) {
                              return Image.file(controller.image.value!, fit: BoxFit.cover);
                            } else if (event.thumbnailImage.isNotEmpty) {
                              return Image.network(imageUrl, fit: BoxFit.cover);
                            } else {
                              return const Center(child: Text('Tap to select image'));
                            }
                          }),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const TextWidget(text: 'Edit Intro Video', fontColor: AppColors.black500, fontSize: 16, fontWeight: FontWeight.w400),
                  const SizedBox(height: 4),
                  DottedBorder(
                    child: InkWell(
                      onTap: controller.pickVideo,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          height: 120,
                          width: double.infinity,
                          child: Obx(() {

                            if (controller.videoFile.value != null) {
                              return Center(child: Text(controller.videoFile.value!.path.split('/').last));
                            } else  if(controller.videoUrl.isNotEmpty){
                              return Text(controller.videoUrl.split('/').last);
                            } else if (event.introMedia.isNotEmpty) {
                              return Center(child: Text('Current: ${event.introMedia.split('/').last}'));
                            } else {
                              return const Center(child: Text('Tap to select video'));
                            }
                          }),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller.eventNameController,
                    decoration: const InputDecoration(labelText: 'Event Name'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller.eventDescriptionController,
                    decoration: const InputDecoration(labelText: 'Event Description'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller.eventTagController,
                    decoration: const InputDecoration(labelText: 'Event Tags (space separated)'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller.priceController,
                    decoration: const InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller.addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller.locationController,
                    decoration: const InputDecoration(labelText: 'Location (lat, lng)'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller.timeController,
                          decoration: const InputDecoration(labelText: 'Event Time'),
                          readOnly: true,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => controller.pickDateTime(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: controller.selectedType.value.isEmpty ? null : controller.selectedType.value,
                    items: ['adult', 'kids', 'family']
                        .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                        .toList(),
                    onChanged: (val) => controller.selectedType.value = val ?? 'Type',
                    decoration: const InputDecoration(labelText: 'Event Type'),
                  ),
                  const SizedBox(height: 32),
                  Obx(()=>controller.isLoading.value?Center(child: CircularProgressIndicator(),):ButtonWidget(
                    onPressed: controller.updateEvent,
                    label: 'Save Changes',
                    buttonWidth: double.infinity,
                    buttonHeight: 48,
                  ),)
                ],
              ),
            )),
    );
  }
}
