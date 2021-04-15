import 'dart:async';

import 'package:elaunch_floor_database/floor_database_demo/Dao/dao_student.dart';
import 'package:elaunch_floor_database/floor_database_demo/database/app_database.dart';
import 'package:elaunch_floor_database/floor_database_demo/model/student.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController nameUpdateController = TextEditingController();
  TextEditingController ageUpdateController = TextEditingController();

  final FocusNode _ageFocus = FocusNode();
  final FocusNode _ageUpdateFocus = FocusNode();

  static var _keyValidationForm = GlobalKey<FormState>();
  static var _keyValidationFormupdate = GlobalKey<FormState>();

  final GlobalKey<FormFieldState> _nameFormKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _ageFormKey = GlobalKey<FormFieldState>();

  final GlobalKey<FormFieldState> _nameUpdatFormKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _ageUpdateFormKey = GlobalKey<FormFieldState>();

  String names, ages;
  int studentId;

  StudentDatabase studentDatabase;
  StudentDao studentDao;

  builder() async {
    studentDatabase = await $FloorStudentDatabase.databaseBuilder('students.db').build();
    setState(() {
      studentDao = studentDatabase.studentDao;
    });
  }

  @override
  void initState() {
    super.initState();
    builder();
    names = nameUpdateController.text;
    ages = ageUpdateController.text;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    ageController.dispose();
    nameUpdateController.dispose();
    ageUpdateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Floor Database'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Form(
              key: _keyValidationForm,
              child: Container(
                color: Colors.indigo[100],
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Column(
                          children: [
                            TextFormField(
                              key: _nameFormKey,
                              controller: nameController,
                              validator: _validateName,
                              onFieldSubmitted: (String value) {
                                FocusScope.of(context).requestFocus(_ageFocus);
                              },
                              onChanged: (value) {
                                setState(() {
                                  names = value;
                                  _nameFormKey.currentState.validate();
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter the name',
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              controller: ageController,
                              key: _ageFormKey,
                              keyboardType: TextInputType.number,
                              focusNode: _ageFocus,
                              validator: _validateAge,
                              onChanged: (value) {
                                setState(() {
                                  ages = value;
                                  _ageFormKey.currentState.validate();
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter the age',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_keyValidationForm.currentState.validate()) {
                          _submit();
                        }
                      },
                      child: Text('Add'),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: StreamBuilder(
                    stream: studentDao?.getAllStudents() ?? Stream.value(<Student>[]),
                    builder: (context, AsyncSnapshot<List<Student>> snapshot) {
                      final studentList = snapshot.data;
                      return studentList != null
                          ? ListView.builder(
                              itemCount: studentList.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: new Container(
                                      child: new Center(
                                        child: new Row(
                                          children: <Widget>[
                                            new CircleAvatar(
                                              radius: 30.0,
                                              child: new Text(
                                                studentList[index].id.toString(),
                                                style: TextStyle(fontSize: 25),
                                              ),
                                              backgroundColor: Colors.indigo,
                                            ),
                                            new Expanded(
                                              child: new Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: new Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Name is : ',
                                                          // set some style to text
                                                          style: new TextStyle(
                                                              fontSize: 20.0,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w600),
                                                        ),
                                                        new Text(
                                                          studentList[index].name,
                                                          // set some style to text
                                                          style: new TextStyle(
                                                              fontSize: 20.0, color: Colors.lightBlueAccent),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Your Age is : ',
                                                          // set some style to text
                                                          style: new TextStyle(
                                                              fontSize: 20.0,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w600),
                                                        ),
                                                        new Text(
                                                          studentList[index].age,
                                                          // set some style to text
                                                          style: new TextStyle(
                                                              fontSize: 20.0, color: Colors.lightBlueAccent),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            new Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                new IconButton(
                                                    icon: const Icon(
                                                      Icons.edit,
                                                      color: Colors.indigo,
                                                    ),
                                                    onPressed: () {
                                                      nameUpdateController.text = studentList[index].name;
                                                      ageUpdateController.text = studentList[index].age;
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return SizedBox(
                                                            child: AlertDialog(
                                                              title: Center(
                                                                  child: Text(
                                                                "Update Data",
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight.w700, fontSize: 25.0),
                                                              )),
                                                              content: Form(
                                                                key: _keyValidationFormupdate,
                                                                child: Column(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    TextFormField(
                                                                      key: _nameUpdatFormKey,
                                                                      controller: nameUpdateController,
                                                                      validator: _validateName,
                                                                      onFieldSubmitted: (String value) {
                                                                        FocusScope.of(context).requestFocus(_ageFocus);
                                                                      },
                                                                      onChanged: (value) {
                                                                        setState(() {
                                                                          names = value;
                                                                          _nameUpdatFormKey.currentState.validate();
                                                                        });
                                                                      },
                                                                      decoration: InputDecoration(hintText: 'name'),
                                                                    ),
                                                                    TextFormField(
                                                                      controller: ageUpdateController,
                                                                      key: _ageUpdateFormKey,
                                                                      keyboardType: TextInputType.number,
                                                                      focusNode: _ageUpdateFocus,
                                                                      validator: _validateAge,
                                                                      onChanged: (value) {
                                                                        setState(() {
                                                                          ages = value;
                                                                          _ageUpdateFormKey.currentState.validate();
                                                                        });
                                                                      },
                                                                      decoration: InputDecoration(hintText: 'age'),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                    onPressed: () async {
                                                                      if (_keyValidationFormupdate.currentState
                                                                          .validate()) {
                                                                        _updatData(studentList[index].id);
                                                                      }
                                                                    },
                                                                    child: Text('ok'))
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      );
                                                      //  dialogBox();
                                                    }),
                                                new IconButton(
                                                  icon: const Icon(Icons.delete_forever, color: Colors.indigo),
                                                  onPressed: () {
                                                    setState(() {
                                                      studentDao.delete(studentList[index].id);
                                                      // print('${studentDao.delete(studentList[index].id)}');
                                                      studentId = studentList[index].id;
                                                      print(studentId);
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0)),
                                );
                              })
                          : Center(
                              child: Text(
                                "Add Data",
                                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w600),
                              ),
                            );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _validateName(String value) {
    return value.trim().isEmpty ? "Name can't be empty" : null;
  }

  String _validateAge(String value) {
    return value.length < 1 ? 'Min 1 char required' : null;
  }

  void _submit() async {
    var user = Student(name: names, age: ages);
    await studentDao.insertStudent(user);
    nameController.clear();
    ageController.clear();
  }

  void _updatData(int id) async {
    await studentDao.updateData(Student(id: id, name: names, age: ages));
    print(studentId);
    Navigator.pop(context);
    nameUpdateController.clear();
    ageUpdateController.clear();
  }
}
