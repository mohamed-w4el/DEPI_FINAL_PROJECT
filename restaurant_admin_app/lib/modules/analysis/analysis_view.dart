import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:restaurant_admin_app/modules/analysis/analysis_controller.dart';
import 'package:restaurant_admin_app/main.dart' as app;

class AnalysisView extends GetView<AnalysisController> {
  const AnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.grey, size: 30),
        ),
        title: Row(
          spacing: 16,
          children: [
            const Icon(Icons.analytics, color: Colors.orangeAccent, size: 40),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "analytics".tr,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Language switcher
          IconButton(
            icon: Text(
              Get.locale?.languageCode == 'en' ? 'AR' : 'EN',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.orangeAccent,
              ),
            ),
            onPressed: () async {
              await app.LocaleManager.toggleLocale();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.orangeAccent),
          );
        }

        if (controller.reviews.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.analytics_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'no_data_available'.tr,
                  style: const TextStyle(fontSize: 32, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.loadReviewData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                  ),
                  child: Text('refresh'.tr),
                ),
              ],
            ),
          );
        }

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Summary Cards
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSummaryCard(
                          'total_reviews'.tr,
                          controller.reviews.length.toString(),
                          Icons.reviews,
                        ),
                        _buildSummaryCard(
                          'total_meals'.tr,
                          controller.meals.length.toString(),
                          Icons.restaurant,
                        ),
                        _buildSummaryCard(
                          'recommend'.tr,
                          '${controller.recommendStats[0].percentage.toStringAsFixed(1)}%',
                          Icons.thumb_up,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Average Ratings Chart
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'average_ratings'.tr,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildAverageRatingsChart(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Recommendation Chart
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'recommendation_distribution'.tr,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildRecommendationChart(),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildLegendItem(
                              Colors.green,
                              '${'yes'.tr} (${controller.recommendStats[0].count})',
                            ),
                            _buildLegendItem(
                              Colors.red,
                              '${'no'.tr} (${controller.recommendStats[1].count})',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Meal Popularity
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'meal_popularity'.tr,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'top_reviewed_meals'.trParams({'count': '5'}),
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildMealPopularityChart(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // Bar chart for average ratings
  Widget _buildAverageRatingsChart() {
    final barChartData = [
      {
        'label': 'food_quality'.tr,
        'value': controller.ratingStats.isNotEmpty
            ? controller.ratingStats[0].averageRating
            : 0.0,
      },
      {
        'label': 'service'.tr,
        'value': controller.ratingStats.length > 1
            ? controller.ratingStats[1].averageRating
            : 0.0,
      },
      {
        'label': 'overall experience'.tr,
        'value': controller.ratingStats.length > 2
            ? controller.ratingStats[2].averageRating
            : 0.0,
      },
    ];

    return AspectRatio(
      aspectRatio: 1.7,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 5.0, // Fixed max at 5 for ratings
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.white,
              tooltipPadding: const EdgeInsets.all(12),
              tooltipMargin: 0,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final data = barChartData[groupIndex];
                return BarTooltipItem(
                  '${data['label']}\n',
                  const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  children: [
                    TextSpan(
                      text: '${data['value'].toString()} ${'stars'.tr}',
                      style: const TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < barChartData.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: SizedBox(
                        width: 120,
                        child: Text(
                          '${barChartData[index]['label']}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  }
                  return const Text('');
                },
                reservedSize: 60,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  );
                },
                interval: 1,
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xffe0e0e0)),
          ),
          barGroups: barChartData.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: (data['value'] as double),
                  width: 40,
                  color: Colors.orangeAccent, // Keeping orange color
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Colors.orangeAccent.shade100,
                      Colors.orangeAccent.shade400,
                      Colors.orangeAccent.shade700,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ],
              showingTooltipIndicators: [0],
            );
          }).toList(),
          gridData: const FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 2,
          ),
        ),
      ),
    );
  }

  // Pie chart for recommendations
  Widget _buildRecommendationChart() {
    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          sectionsSpace: 0,
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {},
          ),
          sections: controller.recommendStats.map((stat) {
            final color = stat.answer == 'Yes' ? Colors.green : Colors.red;
            return PieChartSectionData(
              color: color,
              value: stat.count.toDouble(),
              title: '${stat.percentage.toStringAsFixed(1)}%',
              radius: 150,
              titleStyle: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Meal popularity chart
  Widget _buildMealPopularityChart() {
    final topMeals = controller.mealStats.take(5).toList(); // Show top 5 meals

    return Column(
      children: topMeals.map((meal) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  Get.locale?.languageCode == 'ar'
                      ? meal.mealNameAr
                      : meal.mealNameEn,
                  style: const TextStyle(fontSize: 22),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value:
                            meal.reviewCount /
                            (controller.mealStats.first.reviewCount * 1.2),
                        backgroundColor: Colors.grey[200],
                        color: Colors.blue,
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${meal.reviewCount} ${'reviews'.tr}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Colors.orangeAccent),
        const SizedBox(height: 16),
        Text(
          value,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 24, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 24)),
      ],
    );
  }
}
