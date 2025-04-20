import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/services/models.dart';

class AnimatedProgressbar extends StatelessWidget {
  final double value;
  final double height;

  const AnimatedProgressbar({
    super.key,
    required this.value,
    this.height = 10,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints box) {
        final clampedValue = _clamp(value);

        return Container(
          height: height,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(height),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
              width: box.maxWidth * clampedValue,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(height),
                gradient: LinearGradient(
                  colors: _generateGradient(clampedValue),
                ),
              ),
            ),
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

  List<Color> _generateGradient(double value) {
    if (value < 0.3) {
      return [Colors.redAccent, Colors.orange];
    } else if (value < 0.7) {
      return [Colors.orangeAccent, Colors.amber];
    } else {
      return [Colors.lightGreenAccent, Colors.green];
    }
  }
}

class TopicProgress extends StatelessWidget {
  const TopicProgress({super.key, required this.topic});

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    final report = Provider.of<Report>(context);
    final progress = _calculateProgress(topic, report);
    final completed = report.topics[topic.id]?.length ?? 0;
    final total = topic.quizzes.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$completed / $total',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
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
