import 'package:flutter/material.dart';
import 'package:to_do_list_app/Authtentication/CreateTask.dart';
import 'package:to_do_list_app/Authtentication/Histroy.dart';
import 'package:to_do_list_app/Authtentication/HomeScreen.dart';
import 'package:to_do_list_app/Authtentication/ProfilePage.dart';
import 'package:to_do_list_app/Authtentication/bottom.dart';
import 'package:to_do_list_app/Authtentication/login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Home> {
  int selectedIndex = 0;
  void navigateBottom(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void navigateToPage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List<Widget> _page = [
    const TaskShow(),
    const CreatePage(),
    const HistroyPage(),
    const Profile(),
    const LoginScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 234, 234),
      appBar: AppBar(
        title: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 6, 6, 6))),
            ),
            style: TextStyle(color: Colors.black),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon:
                  const Icon(Icons.search, color: Color.fromRGBO(253, 3, 3, 3)),
              onPressed: () {
                // Perform search functionality here
              },
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            children: [
              const DrawerHeader(
                  child: Center(
                child: Text(
                  'To Do List',
                  style: TextStyle(fontSize: 35),
                ),
              )),
              ListTile(
                leading:
                    const Icon(Icons.home, color: Color.fromRGBO(253, 3, 3, 3)),
                title: const Text('H O M E'),
                onTap: () {
                  navigateToPage(0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person,
                    color: Color.fromRGBO(253, 3, 3, 3)),
                title: const Text('P R O F I L E'),
                onTap: () {
                  navigateToPage(3);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout,
                    color: Color.fromRGBO(253, 3, 3, 3)),
                title: const Text('L O G O U T'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ));
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(
        OnTabChange: (int index) => navigateBottom(index),
      ),
      body: _page[selectedIndex],
    );
  }
}
