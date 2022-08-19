import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mysql_insert_view_delete_update/update_record.dart';

class view_data extends StatefulWidget {
  view_data({Key? key}) : super(key: key);

  @override
  State<view_data> createState() => _view_dataState();
}

class _view_dataState extends State<view_data> {
  List userdata = [];

  Future<void> delrecord(String id) async {
    try {
      String uri = "http://localhost/practice_api/delete_data.php";

      var res = await http.post(Uri.parse(uri), body: {"id": id});
      var response = jsonDecode(res.body);
      if (response["success"] == "true") {
        print("Record deleted");
        getrecord();
      } else {
        print("Some issue");
      }
    } catch (e) {
      print(e);
    }
  }

  getrecord() async {
    String uri = "http://localhost/practice_api/view_data.php";
    try {
      var response = await http.get(Uri.parse(uri));

      setState(() {
        userdata = jsonDecode(response.body);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getrecord();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View data"),
      ),
      body: ListView.builder(
          itemCount: userdata.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => update_record(
                                userdata[index]["uname"],
                                userdata[index]["uemail"],
                                userdata[index]["upassword"],
                              )));
                },
                leading: Icon(Icons.person_sharp),
                title: Text(userdata[index]["uname"]),
                subtitle: Text(userdata[index]["uemail"]),
                trailing: IconButton(
                    onPressed: () {
                      delrecord(userdata[index]["uid"]);
                    },
                    icon: Icon(Icons.delete)),
              ),
            );
          }),
    );
  }
}
