import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/analysis_provider.dart';
import '../widgets/drop_zone.dart';
import '../widgets/result_view.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AnalysisProvider>();
    final hasResults = provider.results != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Check 16KB GUI',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: hasResults ? const ResultView() : const DropZone(),
        ),
      ),
    );
  }
}
