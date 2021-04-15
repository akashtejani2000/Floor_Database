// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorStudentDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$StudentDatabaseBuilder databaseBuilder(String name) =>
      _$StudentDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$StudentDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$StudentDatabaseBuilder(null);
}

class _$StudentDatabaseBuilder {
  _$StudentDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$StudentDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$StudentDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<StudentDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name)
        : ':memory:';
    final database = _$StudentDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$StudentDatabase extends StudentDatabase {
  _$StudentDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  StudentDao _studentDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `students` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `age` TEXT)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  StudentDao get studentDao {
    return _studentDaoInstance ??= _$StudentDao(database, changeListener);
  }
}

class _$StudentDao extends StudentDao {
  _$StudentDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _studentInsertionAdapter = InsertionAdapter(
            database,
            'students',
            (Student item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'age': item.age
                },
            changeListener),
        _studentUpdateAdapter = UpdateAdapter(
            database,
            'students',
            ['id'],
            (Student item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'age': item.age
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Student> _studentInsertionAdapter;

  final UpdateAdapter<Student> _studentUpdateAdapter;

  @override
  Stream<List<Student>> getAllStudents() {
    return _queryAdapter.queryListStream('SELECT * FROM students',
        queryableName: 'students',
        isView: false,
        mapper: (Map<String, dynamic> row) => Student(
            id: row['id'] as int,
            name: row['name'] as String,
            age: row['age'] as String));
  }

  @override
  Future<void> delete(int id) async {
    await _queryAdapter.queryNoReturn('delete from students where id = ?',
        arguments: <dynamic>[id]);
  }

  @override
  Future<void> insertStudent(Student student) async {
    await _studentInsertionAdapter.insert(student, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateData(Student student) async {
    await _studentUpdateAdapter.update(student, OnConflictStrategy.abort);
  }
}
