import 'dart:io';
import 'package:archive/archive_io.dart';
import '../../../domain/entities/analysis_entities.dart';
import 'elf_parser.dart';

class ApkAnalyzerDataSource {
  Future<List<AnalysisResult>> analyzeFile(String filePath) async {
    final file = File(filePath);
    if (!file.existsSync()) {
      return [
        AnalysisResult(
          fileName: filePath,
          isCompliant: false,
          message: 'File not found',
        ),
      ];
    }

    final lowerPath = filePath.toLowerCase();
    List<AnalysisResult> results = [];

    if (lowerPath.endsWith('.apk') ||
        lowerPath.endsWith('.aab') ||
        lowerPath.endsWith('.aar') ||
        lowerPath.endsWith('.zip')) {
      try {
        final bytes = await file.readAsBytes();
        final archive = ZipDecoder().decodeBytes(bytes);

        for (final archiveFile in archive) {
          if (archiveFile.isFile && archiveFile.name.endsWith('.so')) {
            final fileData = archiveFile.content as List<int>;
            final elfResult = ElfParser.check16kbAlignment(fileData);
            results.add(
              AnalysisResult(
                fileName: archiveFile.name,
                isCompliant: elfResult.isAligned,
                message: elfResult.message,
              ),
            );
          }
        }
      } catch (e) {
        results.add(
          AnalysisResult(
            fileName: filePath,
            isCompliant: false,
            message: 'Error decoding archive: \$e',
          ),
        );
      }
    } else if (lowerPath.endsWith('.so')) {
      final bytes = await file.readAsBytes();
      final elfResult = ElfParser.check16kbAlignment(bytes);
      results.add(
        AnalysisResult(
          fileName: file.path.split(Platform.pathSeparator).last,
          isCompliant: elfResult.isAligned,
          message: elfResult.message,
        ),
      );
    } else {
      results.add(
        AnalysisResult(
          fileName: filePath,
          isCompliant: false,
          message:
              'Unsupported file type. Please provide an APK, AAB, ZIP, or .so file.',
        ),
      );
    }

    if (results.isEmpty) {
      results.add(
        AnalysisResult(
          fileName: filePath,
          isCompliant: true,
          message:
              'No .so native libraries found. App does not contain native code.',
        ),
      );
    }

    return results;
  }
}
