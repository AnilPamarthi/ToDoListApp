import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:to_do_list_app/Authtentication/login.dart';

class ResetPassword extends StatefulWidget {
  @override
  final String username;
  ResetPassword({super.key, required this.username});
  _ResetPageState createState() => new _ResetPageState();
}

class _ResetPageState extends State<ResetPassword> {
  final formKey = GlobalKey<FormState>();
  bool isVisible = false;

  final passwordController = TextEditingController();
  final confrimPasswordController = TextEditingController();

  void onPressed(BuildContext context) async {
    String password = passwordController.text;
    String passwordConfrim = confrimPasswordController.text;
    if (password != passwordConfrim) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.grey.shade300,
              title: Text('Password and Confrim Password should be same'),
              content: Text('Please enter same password in both fields.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'ok',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            );
          });
    } else {
      Uri url = Uri.parse("http://localhost:8080/reset-password");
      Map<String, String> headers = {"Content-type": "application/json"};

      String json =
          '{"message": "Hello from Flutter","username": "${widget.username}","password": "$password"}';
      print(json);
      http.Response response =
          await http.post(url, headers: headers, body: json);
      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.grey.shade300,
              title: Text('Verification Successful'),
              content: Text('Password reset successfully. You may now login.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Proceed',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        print('Failed to send data. Status code: ${response.statusCode}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Verification Failed'),
              content:
                  Text('You are not with us. Please check your credentials.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50),
              Image.asset(
                'lib/assets/login.png',
                width: 210,
              ),
              SizedBox(height: 50),
              Text(
                'You are one step away to connect with us :)',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
              ),
              SizedBox(height: 25),
              Container(
                margin: const EdgeInsets.all(8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color.fromRGBO(253, 3, 3, 3).withOpacity(.2),
                ),
                child: TextFormField(
                  controller: passwordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Password is required";
                    }
                    return null;
                  },
                  obscureText: !isVisible,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.lock),
                    border: InputBorder.none,
                    hintText: "Password",
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible; // Toggle button
                        });
                      },
                      icon: Icon(
                          isVisible ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.all(8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color.fromRGBO(253, 3, 3, 3).withOpacity(.2),
                ),
                child: TextFormField(
                  controller: confrimPasswordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Password is required";
                    } else if (passwordController.text !=
                        confrimPasswordController.text) {
                      return "Passwords don't match";
                    }
                    return null;
                  },
                  obscureText: !isVisible,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.lock),
                    border: InputBorder.none,
                    hintText: "Confirm Password",
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible; // Toggle button
                        });
                      },
                      icon: Icon(
                          isVisible ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.symmetric(horizontal: 120),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(253, 3, 3, 3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                  onPressed: () => onPressed(context),
                  child: Center(
                    child: Text(
                      "Verify",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
