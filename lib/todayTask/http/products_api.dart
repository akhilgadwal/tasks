// import 'dart:convert';
// import 'package:http/http.dart' as http;

// import '../model/product.dart';
// //import '../utlis/constants/url.dart';

// // class ProductApi {
// //   List<ProductData> listProducts = [];
// //   static Future<Product> fetchProducts() async {
// //     final response =
// //         await http.get(Uri.parse('${ApiConst.baseUrl}${ApiConst.products}'));
// //     final Map<String, dynamic> data = jsonDecode(response.body);

// //     if (response.statusCode == 200) {
// //       Product productData = Product.fromJson(data);
// //       print(data['products']);
// //       return productData;
// //     } else {
// //       throw Exception('Failed to fetch products');
// //     }
// //   }
// // }

// // class ProductApi {
// //   static Future<Product> fetchProduct() async {
// //     final reponse = await http.get(Uri.parse('https://dummyjson.com/products'));
// //     var data = jsonDecode(reponse.body);

// //     if (reponse.statusCode == 200) {
// //       print(data);
// //       return Product.fromJson(data);
// //     } else {
// //       return Product.fromJson(data);
// //     }
// //   }
// // }

// class ProductApi {
//   static Future<List<Product>> fetchProducts() async {
//     final response =
//         await http.get(Uri.parse('https://dummyjson.com/products'));
//     var data = jsonDecode(response.body);

//     if (response.statusCode == 200) {
//       List<dynamic> productList = data['products'];
//       return productList.map((item) => Product.fromJson(item)).toList();
//     } else {
//       throw Exception('Failed to fetch products');
//     }
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../model/product.dart';

class ProductApi {
  static Future<void> downloadProductsCsv(int page, int limit, int skip) async {
    try {
      // Fetch products data
      final productData = await fetchProducts(page, limit, skip);

      // Convert data to CSV format
      final csvData = convertToCsv(productData);

      // Save CSV file to internal storage
      await saveCsvToInternalStorage(csvData);

      // Show success message to the user
      showMessage('CSV file downloaded successfully');
    } catch (e) {
      // Show error message to the user
      showMessage('Failed to download CSV file');
    }
  }

  static Future<ProductData> fetchProducts(
      int page, int limit, int skip) async {
    final response = await http.get(
        Uri.parse('https://dummyjson.com/products?limit=$limit&skip=$skip'));
    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return ProductData.fromJson(data);
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  static String convertToCsv(ProductData productData) {
    // Convert the product data to CSV format
    // Customize this function according to your data structure
    // Here's a simple example assuming ProductData has name and price fields
    final csvRows = <List<dynamic>>[
      ['Name', 'Price'],
      for (var product in productData.products) [product.id, product.price]
    ];

    // Convert rows to CSV string
    final csvString = const ListToCsvConverter().convert(csvRows);
    return csvString;
  }

  static Future<void> saveCsvToInternalStorage(String csvData) async {
    // Save CSV data to a file in internal storage
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/products.csv');
    await file.writeAsString(csvData);
  }

  static void showMessage(String message) {
    // Display a message to the user
    // Customize this function according to your UI framework (e.g., Flutter, console)
    print(message);
  }
}
