import 'package:flutter/material.dart';
//import 'package:flutter/src/widgets/placeholder.dart';
import 'package:tasks/main.dart';
//import 'package:tasks/todayTask/http/api.dart';

import '../../utlis/global/global_var.dart';

class UiHomePage extends StatefulWidget {
  const UiHomePage({super.key});

  @override
  State<UiHomePage> createState() => _UiHomePageState();
}

class _UiHomePageState extends State<UiHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: bgColorprimary,
          title: const Text('Home Page'),
          automaticallyImplyLeading: false,
        ),
        endDrawer: Drawer(
            child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: bgColorprimary),
              child: CircleAvatar(
                backgroundImage: NetworkImage(user!.image),
                //backgroundColor: Colors.amber,
              ),
            ),
            Column(
              children: [
                const Text(
                  'User Profile',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ListTile(
                  title: Text('Name : ${user!.firstName}'),
                  subtitle: Text('Email: ${user!.email}'),
                  trailing:
                      CircleAvatar(backgroundImage: NetworkImage(user!.image)),
                )
              ],
            )
          ],
        )),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Welcome to Home Screen',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: bgColorSecondary),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: bgColorprimary.withOpacity(0.40)),
                child: Center(
                  child: Column(children: [
                    ListTile(
                      title:
                          Text('Name : ${user!.firstName} ${user!.lastName}'),
                      subtitle: Text('Email : ${user!.email}'),
                      //trailing: Text('ID ' + user!.id.toString()),
                      leading: CircleAvatar(
                          backgroundColor: bgColorSecondary,
                          backgroundImage: NetworkImage(
                            user!.image,
                          )),
                    )
                  ]),
                ),
              )
            ],
          ),
        ));
  }
}
