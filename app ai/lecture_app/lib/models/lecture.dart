import 'dart:convert';

class Lecture {
  final String id;
  final String title;
  final DateTime date;
  final String audioPath;
  String transcript;
  String summary;
  String notes;

  Lecture({
    required this.id,
    required this.title,
    required this.date,
    required this.audioPath,
    this.transcript = '',
    this.summary = '',
    this.notes = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'audioPath': audioPath,
      'transcript': transcript,
      'summary': summary,
      'notes': notes,
    };
  }

  factory Lecture.fromMap(Map<String, dynamic> map) {
    return Lecture(
      id: map['id'],
      title: map['title'],
      date: DateTime.parse(map['date']),
      audioPath: map['audioPath'],
      transcript: map['transcript'] ?? '',
      summary: map['summary'] ?? '',
      notes: map['notes'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Lecture.fromJson(String source) => Lecture.fromMap(json.decode(source));
}
