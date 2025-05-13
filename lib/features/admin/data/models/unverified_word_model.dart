import 'package:cloud_firestore/cloud_firestore.dart';

class UnverifiedWordModel {
  final String id;
   List<String> words;
  final DateTime date;
  UnverifiedWordModel({
    required this.id,
    required this.words,
    required this.date,
  });
  factory UnverifiedWordModel.fromMap(Map<String, dynamic> map, String id) {
    return UnverifiedWordModel(
      id: id,
      words: List<String>.from(map['words']),
      date: (map['date'] as Timestamp).toDate(),
    );
  }
}
