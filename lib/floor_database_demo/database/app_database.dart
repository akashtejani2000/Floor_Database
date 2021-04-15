import 'dart:async';

import 'package:elaunch_floor_database/floor_database_demo/Dao/dao_student.dart';
import 'package:elaunch_floor_database/floor_database_demo/model/student.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

@Database(version: 1, entities: [Student])
abstract class StudentDatabase extends FloorDatabase {
  StudentDao get studentDao;
}
