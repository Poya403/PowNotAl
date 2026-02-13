enum NoteStyle{
  formal,
  friendly,
  summary,
  satirical,
  poetry,
  scientific
}

extension NoteStyleExtension on NoteStyle {
  String get title{
    switch(this){
      case NoteStyle.formal: return 'رسمی';
      case NoteStyle.scientific: return 'علمی';
      case NoteStyle.summary: return 'خلاصه';
      case NoteStyle.satirical: return 'طنز';
      case NoteStyle.poetry: return 'شعر';
      default: return 'دوستانه';
    }
  }
}