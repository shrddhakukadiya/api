import 'package:flutter/material.dart';
import 'package:retry_api/models/student_model.dart';
import 'package:http/http.dart' as http;
import 'package:retry_api/utils/app_config.dart';

class Studentedit extends StatefulWidget {
  const Studentedit({Key? key, required this.studentedit}) : super(key: key);
  final Student studentedit;

  @override
  State<Studentedit> createState() => _StudenteditState();
}

class _StudenteditState extends State<Studentedit> {
  TextEditingController firstnamecontroller = TextEditingController();
  TextEditingController laststnamecontroller = TextEditingController();
  TextEditingController imageurlcontroller = TextEditingController();
  bool isloading = false;
  @override
  void initState() {
    firstnamecontroller.text = widget.studentedit.firstname!;
    laststnamecontroller.text = widget.studentedit.lastname!;
    imageurlcontroller.text = widget.studentedit.CreatedAt!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          TextFormField(
            controller: firstnamecontroller,
            decoration: const InputDecoration(
              hintText: "name",
            ),
          ),
          TextFormField(
            controller: laststnamecontroller,
            decoration: const InputDecoration(
              hintText: "name",
            ),
          ),
          TextFormField(
            controller: imageurlcontroller,
            decoration: const InputDecoration(
              hintText: "Image",
            ),
          ),
          Image.network(
            imageurlcontroller.text,
            errorBuilder: (context, object, st) => const Icon(Icons.info),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: isloading ? null : () => updatedata(context),
              child: const Text("Update"))
        ],
      ),
    );
  }

  updatedata(context) async {
    setState(() {
      isloading = true;
    });
    http.Response response = await http.put(
        Uri.parse("${Appconfig.baseUrl}/students/${widget.studentedit.id}"),
        body: {
          "firstname": firstnamecontroller.text,
          "lastname": laststnamecontroller.text,
          "CreatedAt": imageurlcontroller.text,
        });
    if (response.statusCode == 200) {
      setState(() {
        isloading = false;
        Navigator.pop(context, true);
      });
    }
  }
}
