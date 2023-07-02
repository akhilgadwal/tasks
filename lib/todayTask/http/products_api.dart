import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/product.dart';
//import '../utlis/constants/url.dart';

// class ProductApi {
//   List<ProductData> listProducts = [];
//   static Future<Product> fetchProducts() async {
//     final response =
//         await http.get(Uri.parse('${ApiConst.baseUrl}${ApiConst.products}'));
//     final Map<String, dynamic> data = jsonDecode(response.body);

//     if (response.statusCode == 200) {
//       Product productData = Product.fromJson(data);
//       print(data['products']);
//       return productData;
//     } else {
//       throw Exception('Failed to fetch products');
//     }
//   }
// }

// class ProductApi {
//   static Future<Product> fetchProduct() async {
//     final reponse = await http.get(Uri.parse('https://dummyjson.com/products'));
//     var data = jsonDecode(reponse.body);

//     if (reponse.statusCode == 200) {
//       print(data);
//       return Product.fromJson(data);
//     } else {
//       return Product.fromJson(data);
//     }
//   }
// }

class ProductApi {
  static Future<List<Product>> fetchProducts() async {
    final response =
        await http.get(Uri.parse('https://dummyjson.com/products'));
    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      List<dynamic> productList = data['products'];
      return productList.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch products');
    }
  }
}
