import '../../../domain/entities/analysis_entities.dart';
import '../../../domain/repositories/analysis_repository.dart';
import '../datasources/local/apk_analyzer_datasource.dart';

class AnalysisRepositoryImpl implements AnalysisRepository {
  final ApkAnalyzerDataSource localDataSource;

  AnalysisRepositoryImpl(this.localDataSource);

  @override
  Future<List<AnalysisResult>> analyzeFile(String filePath) {
    return localDataSource.analyzeFile(filePath);
  }
}
