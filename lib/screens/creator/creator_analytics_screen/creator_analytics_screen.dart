import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';
import 'controllers/creator_analytics_controller.dart';
import 'widgets/analytics_box_widget.dart';

class CreatorAnalyticsScreen extends StatefulWidget {
  const CreatorAnalyticsScreen({super.key});

  @override
  State<CreatorAnalyticsScreen> createState() => _CreatorAnalyticsScreenState();
}

class _CreatorAnalyticsScreenState extends State<CreatorAnalyticsScreen> {
  final CreatorAnalyticsController _controller =
      Get.put(CreatorAnalyticsController());

  final List<int> years = [2023, 2024, 2025];
  int selectedYear = 2025;

  @override
  void initState() {
    super.initState();
    _controller.fetchEarnings(selectedYear);
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveUtils.initialize(context);

    return Scaffold(
      backgroundColor: AppColors.whiteBg,
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_controller.earnings.isEmpty) {
          return const Center(child: Text('No data available'));
        }
        if (_controller.analyticsStatus.value.data == null) {
          return const Center(child: Text('No data available'));
        }

        final data = _controller.analyticsStatus.value.data!;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: 'Analytics',
                    fontColor: AppColors.black600,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
              const SpaceWidget(spaceHeight: 16),
              Row(
                children: [
                  Expanded(
                    child: AnalyticsBoxWidget(
                      title: 'Total Earning',
                      count: data.totalEarning ?? 'N/A',
                    ),
                  ),
                  const SpaceWidget(spaceWidth: 8),
                  Expanded(
                    child: AnalyticsBoxWidget(
                      title: 'Total Event',
                      count: data.totalEvent ?? 'N/A',
                    ),
                  ),
                  const SpaceWidget(spaceWidth: 8),
                  Expanded(
                    child: AnalyticsBoxWidget(
                      title: 'Participated',
                      count: data.totalParticipants ?? 'N/A',
                    ),
                  ),
                ],
              ),
              const SpaceWidget(spaceHeight: 24),
              DropdownButton<int>(
                value: selectedYear,
                items: years.map((int year) {
                  return DropdownMenuItem<int>(
                    value: year,
                    child: Text(year.toString()),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedYear = newValue;
                      _controller.fetchEarnings(selectedYear);
                    });
                  }
                },
              ),
              Container(
                width: double.infinity,
                height: ResponsiveUtils.height(300),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: BarChart(
                  BarChartData(
                    maxY: _controller.earnings
                        .map((e) => e.totalEarning?.toDouble() ?? 0)
                        .reduce((a, b) => a > b ? a : b),
                    barGroups: _controller.earnings
                        .asMap()
                        .entries
                        .map((entry) => BarChartGroupData(
                              x: entry.key,
                              barRods: [
                                BarChartRodData(
                                  toY:
                                      entry.value.totalEarning?.toDouble() ?? 0,
                                  color: AppColors.yellow,
                                  width: 10,
                                ),
                              ],
                            ))
                        .toList(),
                    titlesData: FlTitlesData(
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              _controller.earnings[value.toInt()].month ?? '',
                              style: const TextStyle(
                                color: Color(0xff7589a2),
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SpaceWidget(spaceHeight: 100),
            ],
          ),
        );
      }),
    );
  }
}
