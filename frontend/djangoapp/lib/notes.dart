// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Notes {
  int id;
  String note;
  
  Notes({
    required this.id,
    required this.note,
  });

  Notes copyWith({
    int? id,
    String? note,
  }) {
    return Notes(
      id: id ?? this.id,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'note': note,
    };
  }

  factory Notes.fromMap(Map<String, dynamic> map) {
    return Notes(
      id: map['id'] as int,
      note: map['note'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Notes.fromJson(String source) => Notes.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Notes(id: $id, note: $note)';

  @override
  bool operator ==(covariant Notes other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.note == note;
  }

  @override
  int get hashCode => id.hashCode ^ note.hashCode;
}
