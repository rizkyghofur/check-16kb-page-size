import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/datasources/local/apk_analyzer_datasource.dart';
import 'data/repositories/analysis_repository_impl.dart';
import 'domain/usecases/analyze_file_usecase.dart';
import 'presentation/provider/analysis_provider.dart';
import 'presentation/pages/main_page.dart';

void main() {
  final dataSource = ApkAnalyzerDataSource();
  final repository = AnalysisRepositoryImpl(dataSource);
  final useCase = AnalyzeFileUseCase(repository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AnalysisProvider(useCase)),
      ],
      child: const CheckerApp(),
    ),
  );
}

class CheckerApp extends StatelessWidget {
  const CheckerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Check 16KB GUI',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF38BDF8),
          secondary: Color(0xFF818CF8),
          surface: Color(0xFF1E293B),
          error: Color(0xFFF43F5E),
          onSurface: Colors.white,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          titleLarge: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(fontFamily: 'Inter', color: Colors.white70),
        ),
        cardTheme: const CardThemeData(
          color: Color(0xFF1E293B),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
      ),
      home: const MainPage(),
    );
  }
}
