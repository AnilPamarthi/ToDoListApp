import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:to_do_list_app/Authtentication/home.dart';

void main() {
  runApp(const CreatePage());
}

class CreatePage extends StatelessWidget {
  const CreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Form Example',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Change primary color here
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Add Task'),
        ),
        body: const MyForm(),
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  TimeOfDay? _startTime = TimeOfDay.now();
  late TimeOfDay _endTime = TimeOfDay.now();
  String s = "incomplete";

  Future<void> sendDataToBackend() async {
    String sd = DateFormat('yyyy-MM-dd').format(_startDate!);
    String ed = DateFormat('yyyy-MM-dd').format(_endDate);
    DateTime? dst = DateTime(0, 0, 0, _startTime!.hour, _startTime!.minute);
    String st = DateFormat.Hm().format(dst);
    print(st);
    DateTime? det = DateTime(0, 0, 0, _endTime.hour, _endTime.minute);
    String et = DateFormat.Hm().format(det);
    print(st);
    final Map<String, dynamic> requestData = {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'start_date': sd,
      'end_date': ed,
      'start_time': st,
      'end_time': et,
      'status': s,
    };

    final Uri url = Uri.parse(
        'http://localhost:8080/Create'); // Update with your Go server endpoint
    print(requestData);
    try {
      final http.Response response = await http.post(
        url,
        body: jsonEncode(requestData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Data sent successfully');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Add New Task'),
              content: Text('New Task will be Created  Successfully'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(),
                      ),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        print('Failed to send data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 50.0),
            sbuildDateTimePicker('Starting Date', Icons.calendar_today,
                _startDate.toString(), Colors.green), // Change box color here
            const SizedBox(height: 50.0),
            ebuildDateTimePicker('Ending Date', Icons.calendar_today,
                _endDate.toString(), Colors.pink), // Change box color here
            const SizedBox(height: 50.0),
            sbuildTimePicker(
                'Starting Time',
                Icons.access_time,
                _startTime.toString(),
                Colors.lightBlue), // Change box color here
            const SizedBox(height: 50.0),
            ebuildTimePicker('Ending Time', Icons.access_time,
                _endTime.toString(), Colors.orange), // Change box color here
            const SizedBox(height: 50.0),
            ElevatedButton.icon(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  // Process form data here
                  sendDataToBackend();
                  print('Form validated');
                  print('Title: ${_titleController.text}');
                  print('Description: ${_descriptionController.text}');
                  print('Starting Date: $_startDate');
                  print('Ending Date: $_endDate');
                  print('Starting Time: $_startTime');
                  print('Ending Time: $_endTime');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Change button color here
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0), // Decrease length
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(30.0), // Adjust border radius
                ),
              ),
              // Add Google icon
              label: Text(
                'Submit',
                style: TextStyle(color: Colors.black),
                // Change text color here
              ),
              icon: Icon(Icons.send, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget sbuildTimePicker(
      String labelText, IconData icon, String value, Color boxColor) {
    return Row(
      children: <Widget>[
        Text(
          '$labelText: ',
          style: const TextStyle(color: Colors.black), // Change text color here
        ),
        Expanded(
          child: InkWell(
            onTap: () async {
              TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (picked != null && picked != _startTime) {
                setState(() {
                  _startTime = picked;
                });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: boxColor,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    value,
                    style: const TextStyle(
                        color: Colors.black), // Change text color here
                  ),
                  Icon(
                    icon,
                    color: Colors.black, // Change icon color here
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget ebuildTimePicker(
      String labelText, IconData icon, String value, Color boxColor) {
    return Row(
      children: <Widget>[
        Text(
          '$labelText: ',
          style: const TextStyle(color: Colors.black), // Change text color here
        ),
        Expanded(
          child: InkWell(
            onTap: () async {
              TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (picked != null && picked != _endTime) {
                setState(() {
                  _endTime = picked;
                });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: boxColor,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    value,
                    style: const TextStyle(
                        color: Colors.black), // Change text color here
                  ),
                  Icon(
                    icon,
                    color: Colors.black, // Change icon color here
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget sbuildDateTimePicker(
      String labelText, IconData icon, String value, Color boxColor) {
    return Row(
      children: <Widget>[
        Text(
          '$labelText: ',
          style: const TextStyle(color: Colors.black), // Change text color here
        ),
        Expanded(
          child: InkWell(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (picked != null && picked != _startDate) {
                setState(() {
                  _startDate = picked;
                });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: boxColor,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    value,
                    style: const TextStyle(
                        color: Colors.black), // Change text color here
                  ),
                  Icon(
                    icon,
                    color: Colors.black, // Change icon color here
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget ebuildDateTimePicker(
      String labelText, IconData icon, String value, Color boxColor) {
    return Row(
      children: <Widget>[
        Text(
          '$labelText: ',
          style: const TextStyle(color: Colors.black), // Change text color here
        ),
        Expanded(
          child: InkWell(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (picked != null && picked != _endDate) {
                setState(() {
                  _endDate = picked;
                });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: boxColor,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    value,
                    style: const TextStyle(
                        color: Colors.black), // Change text color here
                  ),
                  Icon(
                    icon,
                    color: Colors.black, // Change icon color here
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
