class Note {
  final int id;
  final String body;
  final DateTime updated;
  final DateTime created;

  Note({
    required this.id,
    required this.body,
    required this.updated,
    required this.created,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      body: json['body'],
      updated: DateTime.parse(json['updated']),
      created: DateTime.parse(json['created']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'body': body,
      'updated': updated.toIso8601String(),
      'created': created.toIso8601String(),
    };
  }
}
