import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/analysis_entities.dart';
import '../../domain/usecases/analyze_file_usecase.dart';

class AnalysisProvider extends ChangeNotifier {
  final AnalyzeFileUseCase analyzeFileUseCase;

  AnalysisProvider(this.analyzeFileUseCase);

  bool _isScanning = false;
  bool get isScanning => _isScanning;

  List<AnalysisResult>? _results;
  List<AnalysisResult>? get results => _results;

  String? _filePath;
  String? get filePath => _filePath;

  bool _isDragging = false;
  bool get isDragging => _isDragging;

  void setDragging(bool dragging) {
    _isDragging = dragging;
    notifyListeners();
  }

  Future<void> processFile(String path) async {
    _isScanning = true;
    _results = null;
    _filePath = path;
    notifyListeners();

    _results = await analyzeFileUseCase.execute(path);

    _isScanning = false;
    notifyListeners();
  }

  Future<void> pickFile() async {
    FilePickerResult? pickResult = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['apk', 'aab', 'aar', 'so', 'zip'],
    );

    if (pickResult != null && pickResult.files.single.path != null) {
      await processFile(pickResult.files.single.path!);
    }
  }

  void reset() {
    _results = null;
    _filePath = null;
    _isScanning = false;
    notifyListeners();
  }
}
