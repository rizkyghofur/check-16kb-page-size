import '../entities/analysis_entities.dart';
import '../repositories/analysis_repository.dart';

class AnalyzeFileUseCase {
  final AnalysisRepository repository;

  AnalyzeFileUseCase(this.repository);

  Future<List<AnalysisResult>> execute(String filePath) {
    return repository.analyzeFile(filePath);
  }
}
