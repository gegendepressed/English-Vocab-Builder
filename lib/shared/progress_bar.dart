import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/services/models.dart';

class AnimatedProgressbar extends StatelessWidget {
  final double value;
  final double height;

  const AnimatedProgressbar({
    super.key,
    required this.value,
    this.height = 12,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints box) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: box.maxWidth,
          child: Stack(
            children: [
              Container(
                height: height,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(height),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                height: height,
                width: box.maxWidth * _clamp(value),
                decoration: BoxDecoration(
                  color: _generateColor(value),
                  borderRadius: BorderRadius.circular(height),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double _clamp(double val, [double min = 0.0, double max = 1.0]) {
    if (val.isNaN || val < min) return min;
    if (val > max) return max;
    return val;
  }

  Color _generateColor(double val) {
    final int green = (val * 255).toInt().clamp(0, 255);
    final int red = (255 - green).clamp(0, 255);
    return Colors.deepOrange.withGreen(green).withRed(red);
  }
}

class TopicProgress extends StatelessWidget {
  const TopicProgress({super.key, required this.topic});

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    final report = Provider.of<Report>(context);
    final progress = _calculateProgress(topic, report);

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            '${report.topics[topic.id]?.length ?? 0} / ${topic.quizzes.length}',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: AnimatedProgressbar(value: progress, height: 8),
        ),
      ],
    );
  }

  double _calculateProgress(Topic topic, Report report) {
    try {
      final completed = report.topics[topic.id]?.length ?? 0;
      final total = topic.quizzes.length;
      if (total == 0) return 0.0;
      return completed / total;
    } catch (e) {
      return 0.0;
    }
  }
}
