import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../models/get_job_status_model.dart';
import '../../../widgets/app_image/app_image.dart';
import '../../../widgets/appbar_widget/appbar_widget.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';

class CreatorJobDetailsScreen extends StatelessWidget {
  final AllApplicant? applicant;

  const CreatorJobDetailsScreen({super.key, this.applicant});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: AppColors.whiteBg,
      appBar: const AppbarWidget(text: 'Applicant Details'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: AppImage(
                  url: applicant?.user.profile,
                  height: size.width / (size.width / 100),
                  width: size.width / (size.width / 100),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SpaceWidget(spaceHeight: 24),
            InfoTile(label: "Name:", value: applicant?.user.name ?? ""),
            const SpaceWidget(spaceHeight: 4),
            InfoTile(label: "Address:", value: applicant?.user.location ?? ""),
            const SpaceWidget(spaceHeight: 4),
            InfoTile(label: "Email:", value: applicant?.user.email ?? ""),
            const SpaceWidget(spaceHeight: 4),
            InfoTile(
                label: "Phone Number:", value: applicant?.user.contact ?? ""),
            const SpaceWidget(spaceHeight: 4),
            const TextWidget(
              text: "Q&A",
              fontColor: AppColors.black500,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            const SpaceWidget(spaceHeight: 8),
            ...?applicant?.qna.asMap().entries.map((entry) {
              int index = entry.key + 1;
              Qna qna = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoTile(label: "Question $index:", value: qna.question),
                  InfoTile(label: "Answer:", value: qna.answer),
                  const SpaceWidget(spaceHeight: 8),
                ],
              );
            }),
            const SpaceWidget(spaceHeight: 16),
          ],
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const InfoTile({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: label,
            fontColor: AppColors.black500,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          const SpaceWidget(spaceHeight: 4),
          TextWidget(
            text: value,
            fontColor: AppColors.black400,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }
}
