import 'package:elaunch_floor_database/floor_database_demo/model/student.dart';
import 'package:floor/floor.dart';

@dao
abstract class StudentDao {
  @Query('SELECT * FROM students')
  Stream<List<Student>> getAllStudents();

  @insert
  Future<void> insertStudent(Student student);

  @Query("delete from students where id = :id")
  Future<void> delete(int id);

  @update
  Future<void> updateData(Student student);
}
