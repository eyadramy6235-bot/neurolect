import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/lecture_provider.dart';
import 'recording_screen.dart';
import 'lecture_details_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مكتبة المحاضرات'),
        centerTitle: true,
      ),
      body: Consumer<LectureProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (provider.lectures.isEmpty) {
            return const Center(
              child: Text(
                'لا توجد محاضرات مسجلة بعد.\nاضغط على الزر بالأسفل لبدء تسجيل جديد.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: provider.lectures.length,
            itemBuilder: (context, index) {
              final lecture = provider.lectures[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(lecture.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(DateFormat('yyyy-MM-dd – HH:mm').format(lecture.date)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LectureDetailsScreen(lecture: lecture),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RecordingScreen()),
          );
        },
        child: const Icon(Icons.mic),
      ),
    );
  }
}
