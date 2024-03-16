import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:to_do_list_app/Authtentication/home.dart';
import 'package:to_do_list_app/Authtentication/login.dart';

class SignInButton extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final String text;
  const SignInButton(
      {super.key,
      required this.text,
      required this.usernameController,
      required this.passwordController,
      required Null Function() onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(horizontal: 120),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(253, 3, 3, 3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextButton(
        onPressed: () async {
          String username = usernameController.text;
          String password = passwordController.text;
          Uri url = Uri.parse("http://localhost:8080/send-data");
          Map<String, String> headers = {"Content-type": "application/json"};

          String json =
              '{"message": "Hello from Flutter","username": "$username","password": "$password"}';
          http.Response response =
              await http.post(url, headers: headers, body: json);
          if (response.statusCode == 200) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Log in Successful !')),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Home(),
              ),
            );
            print('Data sent successfully');
          } else {
            print('Failed to send data. Status code: ${response.statusCode}');
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Verification Failed'),
                  content: Text('Invalid User And Password.'),
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
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        },
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
