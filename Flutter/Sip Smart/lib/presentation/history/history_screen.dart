import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gradution_project_smart_sip/providers/hydration_provider.dart';
import 'package:gradution_project_smart_sip/l10n/app_localizations.dart';
import 'package:gradution_project_smart_sip/core/utils/formatters.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final S = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final hydration = Provider.of<HydrationProvider>(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1115) : theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          S.navHistory,
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: Column(
          children: [
           
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    context,
                    S.bestDay, 
                    '${AppFormatters.formatDouble(context, hydration.bestDayValue)} ${S.mlUnit}',
                    hydration.bestDayName,
                    Icons.auto_graph_rounded,
                    const Color(0xFF00E676), 
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInfoCard(
                    context,
                    S.lowestDay, 
                    '${AppFormatters.formatDouble(context, hydration.lowestDayValue)} ${S.mlUnit}',
                    hydration.lowestDayName,
                    Icons.trending_down_rounded,
                    const Color(0xFFD4E157),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    context,
                    S.weeklyAvg,
                    '${AppFormatters.formatDouble(context, hydration.weeklyAverage)} ${S.mlUnit}',
                    S.averagePerDay,
                    Icons.waves_rounded,
                    const Color(0xFF40C4FF),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInfoCard(
                    context,
                    S.goalRate,
                    '${AppFormatters.formatDouble(context, hydration.progress * 100)}%',
                    S.successRate,
                    Icons.emoji_events_rounded,
                    const Color(0xFFFFD740),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            _buildChartContainer(
              context,
              title: S.thisWeek,
              chart: _buildBarChart(context, hydration.weeklyConsumption),
              footer: _buildGoalLegend(context, '${S.dailyGoal}: ${AppFormatters.formatDouble(context, hydration.dailyGoal)} ${S.mlUnit}'),
            ),
            const SizedBox(height: 20),

            _buildChartContainer(
              context,
              title: S.monthlyTrend,
              chart: _buildLineChart(context, hydration.monthlyTrend),
              footer: _buildTrendFooter(context, S.avgConsumptionTrend),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, String value, String? subText, IconData icon, Color accentColor) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1D23) : const Color.fromARGB(255, 248, 247, 247),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: accentColor.withOpacity(isDark ? 0.3 : 0.15),
          width: 1.5,
        ),
        boxShadow: [
          if (isDark)
            BoxShadow(
              color: accentColor.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          else
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: accentColor, size: 22),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white60 : theme.hintColor,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          if (subText != null) ...[
            const SizedBox(height: 6),
            Text(
              subText,
              style: TextStyle(
                color: accentColor.withOpacity(isDark ? 0.9 : 0.7),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChartContainer(BuildContext context, {required String title, required Widget chart, required Widget footer}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1D23) : const Color.fromARGB(255, 248, 247, 247),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: isDark ? Colors.white10 : theme.dividerColor.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 25),
          SizedBox(height: 200, child: chart),
          const SizedBox(height: 20),
          footer,
        ],
      ),
    );
  }

  Widget _buildBarChart(BuildContext context, List<double> data) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BarChart(
      BarChartData(
        maxY: 3500,
        gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (v) => FlLine(color: isDark ? Colors.white : theme.dividerColor.withOpacity(0.1), strokeWidth: 1)),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (v, m) {
                final formatted = AppFormatters.formatDouble(context, v);
                return Text(formatted, style: TextStyle(color: isDark ? Colors.white38 : Colors.grey, fontSize: 9));
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, m) {
                const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(days[v.toInt() % 7], style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 10, fontWeight: FontWeight.bold)),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(data.length, (i) => BarChartGroupData(x: i, barRods: [
          BarChartRodData(
            toY: data[i],
            color: isDark ? const Color(0xFF40C4FF) : theme.primaryColor,
            width: 16,
            borderRadius: BorderRadius.circular(6),
            backDrawRodData: BackgroundBarChartRodData(show: true, toY: 3500, color: isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.03)),
          )
        ])),
      ),
    );
  }

  Widget _buildLineChart(BuildContext context, List<double> data) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? const Color(0xFF00E676) : theme.primaryColor;

    return LineChart(
      LineChartData(
        maxY: 3500,
        gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (v) => FlLine(color: isDark ? Colors.white : theme.dividerColor.withOpacity(0.1), strokeWidth: 1)),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (v, m) {
                final formatted = AppFormatters.formatDouble(context, v);
                return Text(formatted, style: TextStyle(color: isDark ? Colors.white38 : Colors.grey, fontSize: 9));
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, m) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text('W${v.toInt() + 1}', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 10)),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(data.length, (i) => FlSpot(i.toDouble(), data[i])),
            isCurved: true,
            color: accent,
            barWidth: 5,
            dotData: FlDotData(show: true, getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(radius: 5, color: isDark ? const Color(0xFF1A1D23) : Colors.white, strokeWidth: 3, strokeColor: accent)),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [accent.withOpacity(0.3), accent.withOpacity(0.0)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalLegend(BuildContext context, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: Colors.redAccent.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.redAccent, width: 2),
            boxShadow: [if (isDark) const BoxShadow(color: Colors.redAccent, blurRadius: 8, spreadRadius: -2)],
          ),
        ),
        const SizedBox(width: 10),
        Text(text, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTrendFooter(BuildContext context, String label) {
    return Center(child: Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic, color: Colors.grey)));
  }
}