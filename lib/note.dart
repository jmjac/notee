class Note{
  String description;
  String title = "";
  DateTime date;
  int id;

  Note(this.description,  [this.title]){
    this.date = DateTime.now();
    this.id = (this.description+this.title+this.date.toString()).hashCode;
  }

}