class AlignmentResult {
  final bool isAligned;
  final String message;

  AlignmentResult({required this.isAligned, required this.message});
}

class AnalysisResult {
  final String fileName;
  final bool isCompliant;
  final String message;

  AnalysisResult({
    required this.fileName,
    required this.isCompliant,
    required this.message,
  });
}
