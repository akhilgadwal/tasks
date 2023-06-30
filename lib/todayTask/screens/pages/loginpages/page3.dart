import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class ProductData {
  List<Product> products;
  int total;
  int skip;
  int limit;

  ProductData({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    final productsList = json["products"] as List<dynamic>?;

    return ProductData(
      products: productsList != null
          ? List<Product>.from(productsList.map((x) => Product.fromJson(x)))
          : [],
      total: json["total"] ?? 0,
      skip: json["skip"] ?? 0,
      limit: json["limit"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "total": total,
        "skip": skip,
        "limit": limit,
      };
}

class Product {
  int id;
  String title;
  String description;
  int price;
  double? discountPercentage;
  double? rating;
  int stock;
  String brand;
  String category;
  String thumbnail;
  List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.discountPercentage,
    this.rating,
    required this.stock,
    required this.brand,
    required this.category,
    required this.thumbnail,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final imagesList = json["images"] as List<dynamic>?;

    return Product(
      id: json["id"] ?? 0,
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      price: json["price"] ?? 0,
      discountPercentage: json["discountPercentage"]?.toDouble(),
      rating: json["rating"]?.toDouble(),
      stock: json["stock"] ?? 0,
      brand: json["brand"] ?? "",
      category: json["category"] ?? "",
      thumbnail: json["thumbnail"] ?? "",
      images: imagesList != null
          ? List<String>.from(imagesList.map((x) => x.toString()))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "price": price,
        "discountPercentage": discountPercentage,
        "rating": rating,
        "stock": stock,
        "brand": brand,
        "category": category,
        "thumbnail": thumbnail,
        "images": List<dynamic>.from(images.map((x) => x)),
      };
}

class ProductApi {
  static Future<ProductData> fetchProducts(
      int page, int limit, int skip) async {
    final response = await http.get(Uri.parse(
        'https://dummyjson.com/products?limit=11&skip=10&select=title,price,images,brand,category,description'));
    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return ProductData.fromJson(data);
    } else {
      throw Exception('Failed to fetch products');
    }
  }
}

Future<void> requestStoragePermission() async {
  final PermissionStatus status = await Permission.storage.request();
  if (status.isGranted) {
    // Permission granted, proceed with file download
  } else {
    // Permission denied, show an error message or handle it accordingly
  }
}

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> productList = [];
  // List to store the fetched products

  void downloadCSV() async {
    try {
      List<List<dynamic>> rows = [];
      rows.add([
        'ID',
        'Title',
        'Description',
        'Price',
        'Rating',
        'Stock',
        'Brand',
        'Category',
      ]); // Add header row

      for (Product product in productList) {
        rows.add([
          product.id,
          product.title,
          product.description,
          product.price,
          product.rating?.toString() ?? '-',
          product.stock,
          product.brand,
          product.category,
        ]); // Add product data rows
      }

      String csv = const ListToCsvConverter().convert(rows);

      // Request external storage permission
      PermissionStatus permissionStatus = await Permission.storage.request();

      if (permissionStatus.isGranted) {
        Directory? directory = await getExternalStorageDirectory();
        if (directory != null) {
          String filePath = '${directory.path}/product_report.csv';

          File file = File(filePath);
          await file.writeAsString(csv);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('CSV file downloaded successfully'),
            ),
          );

          // Open the downloaded file using the default file viewer
          await launcher.launch(file.path);
        } else {
          throw Exception('Failed to access external storage directory');
        }
      } else {
        throw Exception('Permission denied');
      }
    } catch (e) {
      print('Failed to download CSV file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to download CSV file'),
        ),
      );
    }
  }

  // Future<void> openFile(File file) async {
  //   if (await file.exists()) {
  //     final filePath = file.path;
  //     final url = Uri.file(filePath).toString();
  //     await launchUrl(url)
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('File not found'),
  //       ),
  //     );
  //   }
  //   return;
  // }

  @override
  void initState() {
    super.initState();
    fetchProducts(); // Fetch products when the screen is initialized
  }

  void fetchProducts() async {
    try {
      // Call the API to fetch products
      ProductData productData = await ProductApi.fetchProducts(11, 20, 10);

      setState(() {
        productList = productData.products; // Update the product list
      });
    } catch (e) {
      print('Failed to fetch products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          downloadCSV();
        },
        child: Icon(Icons.download),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Title')),
            DataColumn(label: Text('Description')),
            DataColumn(label: Text('Price')),
            DataColumn(label: Text('Rating')),
            DataColumn(label: Text('Stock')),
            DataColumn(label: Text('Brand')),
            DataColumn(label: Text('Category')),
          ],
          rows: productList.map((product) {
            return DataRow(cells: [
              DataCell(Text(product.id.toString())),
              DataCell(Text(product.title)),
              DataCell(Text(product.description)),
              DataCell(Text(product.price.toString())),
              DataCell(Text(product.rating?.toString() ?? '-')),
              DataCell(Text(product.stock.toString())),
              DataCell(Text(product.brand)),
              DataCell(Text(product.category)),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
