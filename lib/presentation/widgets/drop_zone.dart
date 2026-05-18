import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/analysis_provider.dart';

class DropZone extends StatelessWidget {
  const DropZone({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AnalysisProvider>();
    final isDragging = provider.isDragging;
    final isScanning = provider.isScanning;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: DropTarget(
          onDragDone: (detail) {
            if (detail.files.isNotEmpty) {
              provider.processFile(detail.files.first.path);
            }
          },
          onDragEntered: (detail) => provider.setDragging(true),
          onDragExited: (detail) => provider.setDragging(false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            height: 400,
            decoration: BoxDecoration(
              color: isDragging
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDragging
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(
                        context,
                      ).colorScheme.surface.withValues(alpha: 0.5),
                width: 2,
              ),
              boxShadow: [
                if (isDragging)
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
              ],
            ),
            child: isScanning
                ? _buildScanning(context)
                : _buildIdle(context, provider),
          ),
        ),
      ),
    );
  }

  Widget _buildScanning(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 24),
        Text('Scanning App...', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          'Parsing ELF headers for 16KB alignment',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildIdle(BuildContext context, AnalysisProvider provider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.upload_file,
          size: 80,
          color: provider.isDragging
              ? Theme.of(context).colorScheme.primary
              : Colors.grey,
        ),
        const SizedBox(height: 24),
        Text(
          'Drag & Drop APK, AAB, or .so',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text('or', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          icon: const Icon(Icons.folder_open),
          label: const Text('Browse Files'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: provider.pickFile,
        ),
      ],
    );
  }
}
