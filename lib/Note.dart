
class Note{
  String description;
  String title = "";
  String date;
  int id;

  Note(this.description,  this.title, this.id){
    this.date = DateTime.now().toString();
  }

  Note.fromDatabase(var row){
    this.description = row["description"];
    this.title = row['title'];
    this.date = row["date"];
    this.id = row["_id"];
  }
}