import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:restaurant_admin_app/modules/meal_analytics/meal_analytics_controller.dart';
import 'package:restaurant_admin_app/main.dart' as app;

class MealAnalyticsView extends GetView<MealAnalyticsController> {
  const MealAnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 70,
        elevation: 4,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.grey, size: 30),
        ),
        title: Row(
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Get.locale?.languageCode == 'ar'
                        ? (controller.meal.value?.nameAr ?? 'meal_analytics'.tr)
                        : (controller.meal.value?.nameEn ??
                              'meals_analytics'.tr),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

        if (controller.mealReviews.isEmpty) {
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
                  'no_reviews_yet'.tr,
                  style: const TextStyle(fontSize: 32, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Text(
                  'no_data_available'.trParams({
                    'meal': controller.meal.value?.nameEn ?? 'this meal',
                  }),
                  style: const TextStyle(color: Colors.grey, fontSize: 24),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Performance Overview Card
              _buildPerformanceCard(),

              const SizedBox(height: 16),

              // Key Metrics Cards
              _buildMetricsRow(),

              const SizedBox(height: 16),

              // Rating Distribution Charts
              _buildRatingDistributionChart(),

              const SizedBox(height: 16),

              // Detailed Statistics
              _buildDetailedStats(),

              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPerformanceCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'performance_overview'.tr,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: controller.getPerformanceColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: controller.getPerformanceColor(),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    controller.getPerformanceIndicator().tr,
                    style: TextStyle(
                      color: controller.getPerformanceColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Overall Score
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'overall_score'.tr,
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.averageTotalRating.value.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.orangeAccent,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildStarRating(
                        controller.averageTotalRating.value,
                        size: 24,
                      ),
                    ],
                  ),
                ),

                // Reviews Count
                Container(width: 1, height: 60, color: Colors.grey),

                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'reviews'.tr,
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.reviewsCount.value.toString(),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'total_reviews'.tr,
                        style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                Container(width: 1, height: 60, color: Colors.grey),

                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'recommend'.tr,
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${controller.recommendPercentage.value.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'would_recommend'.tr,
                        style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            'food_quality'.tr,
            controller.averageDishRating.value.toStringAsFixed(1),
            Icons.restaurant,
            Colors.orangeAccent,
            _buildStarRating(controller.averageDishRating.value, size: 24),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _buildMetricCard(
            'service'.tr,
            controller.averageServiceRating.value.toStringAsFixed(1),
            Icons.room_service,
            Colors.blue,
            _buildStarRating(controller.averageServiceRating.value, size: 24),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _buildMetricCard(
            'experience'.tr,
            controller.averageOverallRating.value.toStringAsFixed(1),
            Icons.star,
            Colors.purple,
            _buildStarRating(controller.averageOverallRating.value, size: 24),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
    Widget? subtitle,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 32),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            if (subtitle != null) ...[const SizedBox(height: 8), subtitle],
          ],
        ),
      ),
    );
  }

  Widget _buildRatingDistributionChart() {
    final distributionData = controller.getRatingDistributionForChart();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'rating_distribution'.tr,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'breakdown_ratings'.tr,
              style: const TextStyle(fontSize: 24, color: Colors.grey),
            ),
            const SizedBox(height: 80),

            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _getMaxY(distributionData),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.white,
                      tooltipPadding: const EdgeInsets.all(8),
                      tooltipMargin: 0,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${distributionData[groupIndex]['label']}\n',
                          const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: '${rod.toY.toInt()} ${'reviews'.tr}',
                              style: const TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: 18,
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
                          if (index >= 0 && index < distributionData.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                distributionData[index]['label'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                        reservedSize: 40,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          );
                        },
                        interval: _getInterval(distributionData),
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
                    border: Border.all(
                      color: const Color(0xffe0e0e0),
                      width: 1,
                    ),
                  ),
                  barGroups: distributionData.asMap().entries.map((entry) {
                    final index = entry.key;
                    final data = entry.value;

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: (data['count'] as int).toDouble(),
                          width: 20,
                          color: data['color'] as Color,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                      ],
                      showingTooltipIndicators: [0],
                    );
                  }).toList(),
                  gridData: const FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Legend
            Wrap(
              spacing: 20,
              runSpacing: 8,
              children: distributionData.map((data) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: data['color'],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${data['label']}: ${data['count']}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedStats() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'detailed_statistics'.tr,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Rating Progress Bars
            _buildRatingProgress(
              'food_quality'.tr,
              controller.averageDishRating.value,
              Colors.orangeAccent,
            ),
            const SizedBox(height: 16),
            _buildRatingProgress(
              'service'.tr,
              controller.averageServiceRating.value,
              Colors.blue,
            ),
            const SizedBox(height: 16),
            _buildRatingProgress(
              'overall'.tr,
              controller.averageOverallRating.value,
              Colors.purple,
            ),

            const SizedBox(height: 20),

            // Additional Stats
            const Divider(),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'average_rating_per_review'.tr,
                  style: const TextStyle(fontSize: 24),
                ),
                Text(
                  controller.averageTotalRating.value.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'recommendation_rate'.tr,
                  style: const TextStyle(fontSize: 24),
                ),
                Text(
                  '${controller.recommendPercentage.value.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'total_reviews_analyzed'.tr,
                  style: const TextStyle(fontSize: 24),
                ),
                Text(
                  controller.reviewsCount.value.toString(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),

            // Pie Chart for Rating Distribution
            if (controller.reviewsCount.value > 0) ...[
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),

              Text(
                'rating_composition'.tr,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              SizedBox(height: 500, child: _buildPieChart()),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRatingProgress(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 24)),
            Row(
              children: [
                Text(
                  value.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(width: 4),
                _buildStarRating(value, size: 24),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: value / 5.0,
          backgroundColor: Colors.grey[300],
          color: color,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('1', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
            Text('5', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
          ],
        ),
      ],
    );
  }

  Widget _buildPieChart() {
    final distributionData = controller.getRatingDistributionForChart();
    final totalReviews = controller.reviewsCount.value;

    return PieChart(
      PieChartData(
        sectionsSpace: 0,
        centerSpaceRadius: 180,
        sections: distributionData.map((data) {
          final percentage = totalReviews > 0
              ? ((data['count'] as int) / totalReviews * 100)
              : 0.0;

          return PieChartSectionData(
            color: data['color'] as Color,
            value: percentage,
            title: '${data['rating']}\n${percentage.toStringAsFixed(1)}%',
            radius: 80,
            titleStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            titlePositionPercentageOffset: 0.55,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStarRating(double rating, {double size = 20}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor()
              ? Icons.star
              : (index == rating.floor() && rating % 1 >= 0.5)
              ? Icons.star_half
              : Icons.star_border,
          color: Colors.orangeAccent,
          size: size,
        );
      }),
    );
  }

  double _getMaxY(List<Map<String, dynamic>> distributionData) {
    int maxCount = 0;
    for (final data in distributionData) {
      final count = data['count'] as int;
      if (count > maxCount) {
        maxCount = count;
      }
    }
    // Add some padding to the max Y value
    return (maxCount + 1).toDouble();
  }

  double _getInterval(List<Map<String, dynamic>> distributionData) {
    final maxY = _getMaxY(distributionData);
    if (maxY <= 5) return 1;
    if (maxY <= 10) return 2;
    if (maxY <= 20) return 5;
    return 10;
  }
}
