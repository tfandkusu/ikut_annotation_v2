import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ikut_annotation_v2/main/widget/main_screen.dart';

void main() {
  runApp(const ProviderScope(child: IkutAnnotationApp()));
}

class IkutAnnotationApp extends StatelessWidget {
  const IkutAnnotationApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iKut Annotation',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
