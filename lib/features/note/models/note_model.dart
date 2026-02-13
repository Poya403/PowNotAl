class Note {
  final int? id;
  final String title;
  final String content;
  final String createdDate;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdDate
  });

  Map<String,dynamic> toJson(){
    return {
      'id': id,
      'title': title,
      'content': content,
      'created_date': createdDate
    };
  }

  factory Note.fromJson(Map<String,dynamic> json){
    return Note(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        createdDate: json['created_date']
    );
  }
}
