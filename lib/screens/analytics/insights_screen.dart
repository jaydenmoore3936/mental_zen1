import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart'; 
import '../../services/firestore_service.dart';

class InsightsScreen extends StatelessWidget {
  InsightsScreen({super.key});

  final FirestoreService _firestoreService = FirestoreService();

  Map<String, dynamic> _getMoodDetails(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return {'icon': FontAwesomeIcons.faceSmile, 'color': Colors.amber};
      case 'sad':
        return {'icon': FontAwesomeIcons.faceFrown, 'color': Colors.blue};
      case 'calm':
        return {'icon': FontAwesomeIcons.faceFlushed, 'color': Colors.green};
      default:
        return {'icon': Icons.help_outline, 'color': Colors.grey};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights & Analytics'),
        elevation: 1,
      ),
      body: FutureBuilder<Map<String, int>>(
        future: _firestoreService.getMoodFrequency(30), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading insights: ${snapshot.error}'));
          }

          final moodCounts = snapshot.data ?? {};
          final totalEntries = moodCounts.values.fold(0, (sum, count) => sum + count);

          if (totalEntries == 0) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(30.0),
                child: Text('Log more entries to see your mood trends!', 
                  style: TextStyle(fontStyle: FontStyle.italic)),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Mood Frequency (Last 30 Days)',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      borderData: FlBorderData(show: false),
                      titlesData: const FlTitlesData(
                        show: true, 
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: const FlGridData(show: true, horizontalInterval: 1),
                      barGroups: moodCounts.entries.indexed.map((indexedEntry) {
                        final index = indexedEntry.$1; 
                        final mapEntry = indexedEntry.$2; 
                        final mood = mapEntry.key;
                        final count = mapEntry.value;
                        final details = _getMoodDetails(mood);

                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: count.toDouble(),
                              color: details['color'],
                              width: 20,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ...moodCounts.entries.map((entry) {
                  final mood = entry.key;
                  final count = entry.value;
                  final percentage = count / totalEntries;
                  final details = _getMoodDetails(mood);

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                FaIcon(details['icon'], color: details['color'], size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  '${mood[0].toUpperCase()}${mood.substring(1)}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Text('${(percentage * 100).toStringAsFixed(1)}% ($count entries)'),
                          ],
                        ),
                        const SizedBox(height: 5),
                        LinearProgressIndicator(
                          value: percentage,
                          color: details['color'],
                          backgroundColor: Colors.grey[200],
                          minHeight: 10,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}