import 'package:floor/floor.dart';

@Entity(tableName: 'students')
class Student {
  @PrimaryKey(autoGenerate: true)
  int id;
  String name;
  String age;

  Student({this.id, this.name, this.age});
}
