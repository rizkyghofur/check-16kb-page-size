import '../entities/analysis_entities.dart';

abstract class AnalysisRepository {
  Future<List<AnalysisResult>> analyzeFile(String filePath);
}
