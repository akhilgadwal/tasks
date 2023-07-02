import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:tasks/todayTask/model/user.dart';

import '../screens/pages/home.dart';
import '../utlis/constants/url.dart';

// class ApiServices {
//   static Future<UserModel?> login(
//       String email, password, BuildContext context) async {
//     {
//       Response response = await post(
//           Uri.parse('${ApiConst.baseUrl}${ApiConst.login}'),
//           body: {'username': email, 'password': password});

//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//         UserModel cUser = UserModel.fromJson(data);
//         print(data);
//         // print(data['token']);
//         // print(data['firstName']);
//         print('Login successfully');
//         // Show snackbar
//         // ignore: use_build_context_synchronously
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Login Successful'),
//           ),
//         );
//         Navigator.push(
//             context, MaterialPageRoute(builder: (context) => UiHomePage()));
//         return cUser;
//       } else if (response.statusCode == 400) {
//         print('Invalid credentials');
//         // ignore: use_build_context_synchronously
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Invalid credentials'),
//           ),
//         );
//       }
//       return null;
//     }
//   }

//   //getting the data from post
// }

class ApiServices {
  static Future<UserModel?> login(
      String email, password, BuildContext context) async {
    {
      Response response = await post(
          Uri.parse('${ApiConst.baseUrl}${ApiConst.login}'),
          body: {'username': email, 'password': password});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          UserModel cUser = UserModel.fromJson(data);
          print(data);
          // print(data['token']);
          // print(data['firstName']);
          print('Login successfully');
          // Show snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login Successful'),
            ),
          );
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const UiHomePage()));
          return cUser;
        }
      } else if (response.statusCode == 400) {
        print('Invalid credentials');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid credentials'),
          ),
        );
      }
      return null;
    }
  }

  //getting the data from post
}
