import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/lecture.dart';
import '../providers/lecture_provider.dart';
import '../services/ai_service.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  late AudioRecorder _audioRecorder;
  bool _isRecording = false;
  bool _isProcessing = false;
  String _recordingStatus = "اضغط لبدء التسجيل";
  int _recordDuration = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  void _startTimer() {
    _recordDuration = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _startRecording() async {
    try {
      if (await Permission.microphone.request().isGranted) {
        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
        
        await _audioRecorder.start(const RecordConfig(), path: path);
        _startTimer();
        
        setState(() {
          _isRecording = true;
          _recordingStatus = "جاري التسجيل...";
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يجب السماح باستخدام الميكروفون')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ في التسجيل: $e')));
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      _timer?.cancel();
      
      setState(() {
        _isRecording = false;
        _isProcessing = true;
        _recordingStatus = "جاري معالجة الصوت والتلخيص...";
      });

      if (path != null) {
        // Here we call the AI Service for transcription and summary
        String transcript = await AIService.transcribeAudio(path);
        String summary = await AIService.summarizeText(transcript);
        
        final newLecture = Lecture(
          id: const Uuid().v4(),
          title: 'محاضرة ${_formatDuration(_recordDuration)} - ${DateTime.now().day}/${DateTime.now().month}',
          date: DateTime.now(),
          audioPath: path,
          transcript: transcript,
          summary: summary,
          notes: '',
        );

        if (!mounted) return;
        
        await Provider.of<LectureProvider>(context, listen: false).addLecture(newLecture);
        Navigator.pop(context); // Go back to library
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _recordingStatus = "حدث خطأ";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل محاضرة جديدة')),
      body: Center(
        child: _isProcessing
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(_recordingStatus, style: const TextStyle(fontSize: 18)),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _formatDuration(_recordDuration),
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: _isRecording ? _stopRecording : _startRecording,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isRecording ? Colors.red : Colors.blue,
                      ),
                      child: Icon(
                        _isRecording ? Icons.stop : Icons.mic,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(_recordingStatus, style: const TextStyle(fontSize: 18)),
                ],
              ),
      ),
    );
  }
}
