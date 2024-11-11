class Note {
  final int? id;
  final String title;
  final String content;
  final String lastEdited;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.lastEdited,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'lastEdited': lastEdited,
    };
  }

  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      lastEdited: map['lastEdited'],
    );
  }
}