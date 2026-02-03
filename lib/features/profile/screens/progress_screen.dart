import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/profile_provider.dart';
import '../models/profile_models.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_error_state.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final progressAsync = ref.watch(progressDataProvider);

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        title: Text("Learning Insights", style: AppTheme.titleStyle),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textDark,
        elevation: 0,
      ),
      body: progressAsync.when(
        data: (data) => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Banner
              _buildSummaryBanner(),
              
              const SizedBox(height: 24),
              
              // Activity Chart
              const Text("Weekly Activity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
              const SizedBox(height: 16),
              _buildActivityChart(data.weeklyProgress),
              
              const SizedBox(height: 32),
              
              // Subject Performance
              const Text("Subject Proficiency", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
              const SizedBox(height: 16),
              _buildSubjectGrid(),
              
              const SizedBox(height: 32),
              
              // Performance Distribution
              const Text("Accuracy Distribution", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
              const SizedBox(height: 16),
              _buildPieChart(),
              
              const SizedBox(height: 120),
            ],
          ),
        ),
        loading: () => Center(
          child: SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(strokeWidth: 2.5, color: AppTheme.primaryBlue),
          ),
        ),
        error: (err, stack) => EmptyErrorState(
          message: 'Couldn\'t load progress',
          subtitle: 'We couldn\'t load your insights. Try again.',
          icon: Icons.analytics_outlined,
          onRetry: () => ref.invalidate(progressDataProvider),
        ),
      ),
    );
  }

  Widget _buildSummaryBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(AppTheme.cardRadiusLarge),
        boxShadow: [
          BoxShadow(color: AppTheme.primaryBlue.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          const Text("Average Accuracy", style: TextStyle(color: Colors.white70, fontSize: 14)),
          const Text("84.5%", style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.trending_up, color: Colors.greenAccent, size: 18),
                SizedBox(width: 6),
                Text("+5.2% from last week", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityChart(List<DailyProgress> dailyProgress) {
    return Container(
      height: 240,
      padding: const EdgeInsets.fromLTRB(10, 24, 24, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.cardRadiusLarge),
        boxShadow: AppTheme.softShadow,
      ),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                  if (value.toInt() >= 0 && value.toInt() < days.length) {
                    return Text(days[value.toInt()], style: const TextStyle(color: AppTheme.textGrey, fontSize: 10, fontWeight: FontWeight.bold));
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 1.5),
                FlSpot(1, 2.8),
                FlSpot(2, 1.2),
                FlSpot(3, 4.5),
                FlSpot(4, 3.2),
                FlSpot(5, 5.0),
                FlSpot(6, 4.2),
              ],
              isCurved: true,
              gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF4F46E5)]),
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [const Color(0xFF2563EB).withOpacity(0.2), const Color(0xFF2563EB).withOpacity(0.0)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectGrid() {
    final subjects = [
      {'name': 'Physics', 'score': 0.85, 'color': Colors.blue, 'icon': Icons.bolt},
      {'name': 'Chemistry', 'score': 0.72, 'color': Colors.orange, 'icon': Icons.science},
      {'name': 'Maths', 'score': 0.92, 'color': Colors.green, 'icon': Icons.functions},
      {'name': 'English', 'score': 0.68, 'color': Colors.purple, 'icon': Icons.translate},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.3,
      ),
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        final sub = subjects[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.cardRadius),
            boxShadow: AppTheme.softShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(sub['icon'] as IconData, color: sub['color'] as Color, size: 20),
                  Text("${((sub['score'] as double) * 100).toInt()}%", style: TextStyle(fontWeight: FontWeight.bold, color: sub['color'] as Color)),
                ],
              ),
              Text(sub['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textDark)),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: sub['score'] as double,
                  backgroundColor: (sub['color'] as Color).withOpacity(0.1),
                  color: sub['color'] as Color,
                  minHeight: 6,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPieChart() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.cardRadiusLarge),
        boxShadow: AppTheme.softShadow,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(color: Colors.green, value: 65, title: '65%', radius: 45, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                  PieChartSectionData(color: Colors.red, value: 20, title: '20%', radius: 45, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                  PieChartSectionData(color: Colors.orange, value: 15, title: '15%', radius: 45, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPieLegend(Colors.green, "Correct"),
                const SizedBox(height: 12),
                _buildPieLegend(Colors.red, "Incorrect"),
                const SizedBox(height: 12),
                _buildPieLegend(Colors.orange, "Skipped"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieLegend(Color color, String label) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textGrey, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
