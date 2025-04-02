import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/services/models.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {

    Report report = Provider.of<Report>(context);
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 3,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ReportLoadingWrapper extends StatelessWidget {
  const ReportLoadingWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Using the provider to watch for the Report object
    return Consumer<Report>(
      builder: (context, report, child) {
        // Assuming that report has a field or method to track its loading state
        // If `report` is null or empty, show the loading indicator
        if (report.topics.isEmpty && report.total == 0) {
          return const Loading(); // Show loading if the report is empty or still being fetched
        } else {
          return child ?? Container(); // Otherwise, show the content or a default container
        }
      },
      child: Container(), // This child widget will be displayed when report is ready
    );
  }
}
