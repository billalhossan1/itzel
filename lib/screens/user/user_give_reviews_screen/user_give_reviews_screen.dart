import 'package:flutter/material.dart';
import 'package:itzel/utils/app_size.dart';
import 'package:itzel/widgets/space_widget/space_widget.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/appbar_widget/appbar_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';

class UserGiveReviewsScreen extends StatelessWidget {
  const UserGiveReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.whiteBg,
      appBar: AppbarWidget(
        text: 'Back',
      ),
      body: RecsTab(),
    );
  }
}

class RecsTab extends StatefulWidget {
  const RecsTab({super.key});

  @override
  State<RecsTab> createState() => _RecsTabState();
}

class _RecsTabState extends State<RecsTab> {
  final List<Map<String, dynamic>> posts = [
    {
      'name': 'Itzel',
      'role': 'Influencer',
      'question':
          'What are the best American cuisine restaurants in and around 278 Broadway, New York, NY 10007, USA?',
      'date': 'Now',
      'answers': 1,
      'answerText': 'The best American cuisine restaurant is XYZ.',
      'showAnswer': false,
    },
    {
      'name': 'Hany',
      'role': '',
      'question':
          'What are the best restaurants in and around Arlington, TX 76005?',
      'date': 'Nov 29',
      'answers': 1,
      'answerText': 'The best restaurant in Arlington is ABC.',
      'showAnswer': false,
    },
    {
      'name': 'Joey Gennaro',
      'role': '',
      'question':
          'What are the best Indian cuisine restaurants in and around New Haven, CT?',
      'date': 'Jul 01',
      'answers': 1,
      'answerText': 'The best Indian cuisine restaurant is DEF.',
      'showAnswer': false,
    },
  ];

  void _toggleAnswerVisibility(int index) {
    setState(() {
      posts[index]['showAnswer'] = !posts[index]['showAnswer'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                  ),
                  const SpaceWidget(spaceWidth: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: post['name'],
                        fontColor: AppColors.black500,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      if (post['role'] != '')
                        TextWidget(
                          text: post['role'],
                          fontColor: AppColors.black200,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                    ],
                  ),
                  const Spacer(),
                  TextWidget(
                    text: post['date'],
                    fontColor: AppColors.black200,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
              const SpaceWidget(spaceHeight: 12),
              TextWidget(
                text: post['question'],
                fontColor: AppColors.black500,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                textAlignment: TextAlign.start,
              ),
              const SpaceWidget(spaceHeight: 8),
              GestureDetector(
                onTap: () => _toggleAnswerVisibility(index),
                child: TextWidget(
                  text: '${post['answers']} answer',
                  fontColor: AppColors.black200,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (post['showAnswer'])
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              'assets/images/replyAnswerImage.jpg',
                              height: ResponsiveUtils.width(30),
                              width: ResponsiveUtils.width(30),
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SpaceWidget(spaceWidth: 8),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                text: 'John Doe',
                                fontColor: AppColors.black500,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                textAlignment: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              SpaceWidget(spaceHeight: 2),
                              TextWidget(
                                text: '1h ago',
                                fontColor: AppColors.grey700,
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                textAlignment: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SpaceWidget(spaceHeight: 8),
                      SizedBox(
                        width: ResponsiveUtils.width(350),
                        child: TextWidget(
                          text: post['answerText'],
                          fontColor: AppColors.black500,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          textAlignment: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                        ),
                      ),
                    ],
                  ),
                ),
              const SpaceWidget(spaceHeight: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.black500),
                      decoration: InputDecoration(
                        hintText: 'Write your answer',
                        hintStyle: const TextStyle(
                            fontSize: 13, color: AppColors.grey700),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: AppColors.grey100),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.send,
                      color: AppColors.black,
                      size: 30,
                    ),
                  ),
                ],
              ),
              const SpaceWidget(spaceHeight: 8),
              if (index != posts.length - 1)
                Divider(thickness: 1, color: Colors.grey[300]),
            ],
          ),
        );
      },
    );
  }
}
