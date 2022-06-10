// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_10/api/funtion.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Createddata obj = Createddata();
  TextEditingController municipalityController = TextEditingController();
  TextEditingController barangayController = TextEditingController();
  TextEditingController deathsController = TextEditingController();
  TextEditingController recoveredController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getdata();
    update(id);
    datadelet(id);

    obj.datacreated(municipalityController.text, barangayController.text, deathsController.text, recoveredController.text, monthController);
  }

  List data = [];
  String? id;
  Future getdata() async {
    final response =
    await http.get(Uri.parse('http://192.168.43.14:8000/api/dengue-info/'));
    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body);
      });
      print('Add data$data');
    } else {
      print('error');
    }
  }

  Future datadelet(id) async {
    final responce = await http
        .delete(Uri.parse('http://192.168.43.14:8000/api/dengue-info-delete/$id'));
    print(responce.statusCode);

    if (responce.statusCode == 200) {
      print('DELETE COMPLETE');
    } else {
      print('nOT dELET');
    }
  }

  Future update(id) async {
    final responce = await http
        .put(Uri.parse('http://192.168.43.14:8000/api/dengue-info/edit/$id'),
        body: jsonEncode({
          "municipality": municipalityController.text,
          "barangay":barangayController.text,
          "deaths":deathsController.text,
          "recovered":recoveredController.text,
          "month":monthController.text,
        }),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        });
    print(responce.statusCode);
    if (responce.statusCode == 200) {
      print('Data Update Successfully');
      municipalityController.clear();
      barangayController.clear();
      deathsController.clear();
      recoveredController.clear();
      monthController.clear();
    } else {
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Dengue Tracker'),
          backgroundColor: Colors.redAccent,
        ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            child: Column(
              children: [
                TextField(
                  controller: municipalityController,
                  decoration: InputDecoration(
                    hintText: 'Municipality',
                  ),
                ),
                TextField(
                  controller: barangayController,
                  decoration: InputDecoration(
                    hintText: 'Barangay',
                  ),
                ),
                TextField(
                  controller: deathsController,
                  decoration: InputDecoration(
                    hintText: 'Deaths',
                  ),
                ),
                TextField(
                  controller: recoveredController,
                  decoration: InputDecoration(
                    hintText: 'Recovered',
                  ),
                ),
                TextField(
                  controller: monthController,
                  decoration: InputDecoration(
                    hintText: 'Month',
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            obj.datacreated(
                              municipalityController.text,
                              barangayController.text,
                              deathsController.text,
                              recoveredController.text,
                              monthController.text,
                            );
                          });
                        },
                        child: Text('Submit')),

                  ],
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(data[index]['municipality']),
                                ],
                              ),
                              Row(
                              children: [
                              Text(data[index]['barangay']),
                              ],
                              ),
                              Row(
                              children: [
                              Text(data[index]['deaths']),
                        ],
                        ),
                              Row(
                              children: [
                              Text(data[index]['recovered']),
                              ],
                              ),
                              Row(
                              children: [
                              Text(data[index]['month']),
                              ],
                              ),

                            Container(
                              width: 150,
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        municipalityController.text =
                                        data[index]['municipality'];

                                        barangayController.text =
                                        data[index]['barangay'];

                                        deathsController.text =
                                        data[index]['deaths'];

                                        recoveredController.text =
                                        data[index]['recovered'];

                                        monthController.text =
                                        data[index]['month'];

                                      },
                                      icon: Icon(Icons.edit)),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          datadelet(data[index]['id']);
                                        });
                                      },
                                      icon: Icon(Icons.delete)),

                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          update(data[index]['id']);
                                        });
                                      },
                                      icon: Icon(Icons.book)),
                                ],
                              ),
                            ),
                                ]
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

