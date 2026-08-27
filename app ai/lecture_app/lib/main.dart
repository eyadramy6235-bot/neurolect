import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/lecture_provider.dart';
import 'screens/library_screen.dart';

void main() {
  runApp(const LectureApp());
}

class LectureApp extends StatelessWidget {
  const LectureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LectureProvider()),
      ],
      child: MaterialApp(
        title: 'محاضراتي (Lectures)',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Tajawal', 
        ),
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl, // RTL for Arabic layout
            child: child!,
          );
        },
        home: const LibraryScreen(),
      ),
    );
  }
}
