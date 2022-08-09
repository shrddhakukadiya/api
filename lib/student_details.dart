// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:retry_api/models/student_model.dart';
import 'package:http/http.dart' as http;
import 'package:retry_api/utils/app_config.dart';
import 'package:retry_api/view/student_edit.dart';

class StudentDetails extends StatefulWidget {
  const StudentDetails({Key? key, required this.student}) : super(key: key);
  final Student student;

  @override
  State<StudentDetails> createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  Student? student;
  bool isLoading = false;
  bool refresh=false;
  @override
  void initState() {
   
    super.initState();
     getstudentdetails();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: ()async{
          Navigator.pop(context,refresh);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(onPressed: ()=>Navigator.pop(context,refresh), icon: Icon(Icons.arrow_back_rounded)),
            actions: [
              IconButton(onPressed: () => edit(context), icon:const Icon(Icons.edit))
            ],
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : Center(
                  child: Column(
                    children: [
                      Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.amber,
                              image: DecorationImage(
                                  image: NetworkImage(
                                    "${widget.student.CreatedAt}",
                                  ),
                                  fit: BoxFit.cover))),
                      Text("First name: ${widget.student.firstname}"),
                      Text("Last name: ${widget.student.lastname}"),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  void getstudentdetails() async {
    http.Response response = await http
        .get(Uri.parse("${Appconfig.baseUrl}.students/${widget.student.id}"));
  }

  edit(BuildContext context) async {
    
      var isEdited = await showDialog(
          context: context,
          builder: (context) => Studentedit(
                studentedit: widget.student,
              ));
      if (isEdited == true) {
        Navigator.pop(context, true);
      
    }
  }
}
