import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:retry_api/utils/app_config.dart';
import 'package:retry_api/view/student_details.dart';

import '../models/student_model.dart';

class StudentList123 extends StatefulWidget {
  const StudentList123({Key? key}) : super(key: key);

  @override
  State<StudentList123> createState() => _StudentList123State();
}

class _StudentList123State extends State<StudentList123> {
  List<Student> userss = [];
  List<Student> alluserss = [];

  @override
  bool isLoading = false;
  bool isdelete = false;
  String query = '';
  final validations = GlobalKey<FormState>();

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController mobailnumberController = TextEditingController();
  TextEditingController avatarController = TextEditingController();
  @override
  void initState() {
    firstnameController.text = "shrddha";
    getstudentsI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: TextFormField(
            onChanged: (v) {
              query = v;
            },
            onEditingComplete: () {
              List<Student> newlist = [];
              for (var st in alluserss) {
                if (st.firstname!.toLowerCase().contains(query) ||
                    st.lastname!.toLowerCase().contains(query)) {
                  newlist.add(st);
                }
              }
              setState(() {
                if (newlist.isNotEmpty) {
                  userss = newlist;
                } else {
                  userss = alluserss;
                }
              });
            },
            decoration: const InputDecoration(hintText: "Search name"),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
                onTap: (() {
                  firstnameController.clear();
                  lastnameController.clear();
                  mobailnumberController.clear();
                  avatarController.clear();
                  // getstudentsI();
                }),
                child: const Icon(Icons.rotate_left)),
          )
        ],
      ),
      body: userss.isEmpty
          ? const Center(child: Text("No students"))
          : ListView.builder(
              itemCount: userss.length,
              itemBuilder: (context, index) => ListTile(
                onTap: (() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StudentDetails(
                                student: userss[index],
                              )));
                }),
                title: Text(
                    "${userss[index].firstname} ${userss[index].lastname}  "),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    userss[index].CreatedAt!,
                  ),
                  radius: 25,
                ),
                trailing: IconButton(
                    onPressed: () {
                      detelestudentapi(userss[index].id);
                    },
                    icon: const Icon(Icons.delete)),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void getstudentsI() async {
    setState(() {
      isLoading = true;
    });

    var res = await http.get(Uri.parse("${Appconfig.baseUrl}/students"));
    print(res.body);
    print(res.statusCode);
    if (res.statusCode == 200) {
      var decoded = jsonDecode(res.body);
      print(decoded.runtimeType);
      if (decoded is List) {
        for (var stud in decoded) {
          userss.add(Student.fromMap(stud as Map<String, dynamic>));
        }
        alluserss = userss;
      }
      setState(() {
        isLoading = false;
      });
    }
    print(userss);
  }

  void _showDialog() async {
    var isAdded = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: AlertDialog(
              title: const Center(child: Text("Personal Information")),
              content: Form(
                key: validations,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Card(
                        elevation: 10,
                        child: TextFormField(
                          controller: firstnameController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(11),
                            ),
                            filled: true,
                            fillColor: Colors.blue[50],
                            hintText: "enter your firstname ",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "enter firstname";
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Card(
                        elevation: 10,
                        child: TextFormField(
                          controller: lastnameController,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(11),
                              ),
                              filled: true,
                              fillColor: Colors.blue[50],
                              hintText: "enter your lastname "),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "enter lastname";
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Card(
                        elevation: 10,
                        child: TextFormField(
                          controller: mobailnumberController,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(11),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.blue[50],
                              hintText: "enter your mono "),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "enter mono";
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Card(
                        elevation: 10,
                        child: TextFormField(
                          controller: avatarController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(11),
                            ),
                            filled: true,
                            fillColor: Colors.blue[50],
                            hintText: "enter your url ",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "enter url";
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      height: 55,
                      width: 220,
                      child: ElevatedButton(
                          onPressed: () {
                            if (validations.currentState!.validate()) {
                              Addstudentapi(context);
                              Navigator.pop(context, true);
                            }
                          },
                          style: ButtonStyle(
                            shadowColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.redAccent;
                                }
                                return null;
                              },
                            ),
                          ),
                          child: const Text("Submit")),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 55,
                      width: 220,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            shadowColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.redAccent;
                                }
                                return null;
                              },
                            ),
                          ),
                          child: const Text("cancel")),
                    )
                  ],
                ),
              ),
            ),
          );
        });
    if (isAdded != null && isAdded) {
      // getstudentsI();
    }
  }

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    mobailnumberController.dispose();
    avatarController.dispose();
    super.dispose();
  }

  void Addstudentapi(context) async {
    http.Response response = await http.post(
      Uri.parse("${Appconfig.baseUrl}/students"),
      body: {
        "firstname": firstnameController.text,
        "lastname": lastnameController.text,
        "MobileNo": mobailnumberController.text,
        "CreatedAt": avatarController.text,
      },
    );

    if (response.statusCode == 201) {
      firstnameController.clear();
      lastnameController.clear();
      mobailnumberController.clear();
      avatarController.clear();
    }
  }

  detelestudentapi(id) async {
    http.Response response = await http.delete(
      Uri.parse("${Appconfig.baseUrl}/students/$id"),
    );

    if (response.statusCode == 200) {
      // getstudentsI();

    }
  }
}
