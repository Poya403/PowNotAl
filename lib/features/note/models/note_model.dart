class Note {
  final int? id;
  final String title;
  final String content;
  final String createdDate;
  final String? status;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdDate,
    this.status = 'untrash'
  });

  Map<String,dynamic> toJson(){
    return {
      'id': id,
      'title': title,
      'content': content,
      'created_date': createdDate,
      'status': status
    };
  }

  factory Note.fromJson(Map<String,dynamic> json){
    return Note(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        createdDate: json['created_date'],
        status: (json['status'] as String?) ?? 'untrash'
    );
  }
}
