import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tasks/main.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:tasks/todayTask/utlis/global/global_var.dart';

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
  static Future<ProductData> fetchProducts(int limit, int skip) async {
    final response = await http.get(
        Uri.parse('https://dummyjson.com/products?limit=$limit&skip=$skip'));
    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return ProductData.fromJson(data);
    } else {
      throw Exception('Failed to fetch products');
    }
  }
}

List<Product> productList = [];
//saving files in saver folder

// Future<void> downloadCSV() async {
//   List<List<dynamic>> csvData = [];

//   // Add table header
//   csvData.add([
//     'ID',
//     'Title',
//     'Description',
//     'Price',
//     'Rating',
//     'Stock',
//     'Brand',
//     'Category',
//   ]);

//   // Add product rows
//   for (var product in productList) {
//     csvData.add([
//       product.id,
//       product.title,
//       product.description,
//       product.price,
//       product.rating ?? '-',
//       product.stock,
//       product.brand,
//       product.category,
//     ]);
//   }

//   // Get the directory path using path_provider
//   Directory? directory = await getExternalStorageDirectory();
//   if (directory != null) {
//     String filePath = '${directory.path}/product_list.csv';
//     File csvFile = File(filePath);

//     // Convert CSV data to String
//     String csvString = const ListToCsvConverter().convert(csvData);

//     // Write the CSV data to the file
//     await csvFile.writeAsString(csvString);

//     // Open the CSV file
//     await OpenFile.open(filePath);

//     print('CSV file saved and opened successfully');
//   } else {
//     print('Failed to access directory');
//   }
// }

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> productList = [];
  String? filePath;
  int page = 1;
  int limit = 10;
  int skip = 0; // Initial skip value
  bool isLoading = false;
  bool hasMoreData = true;
  int selectedIndex = 0;
  bool isdonwloading = false;

  @override
  void initState() {
    super.initState();
    fetchProducts(); // Load initial data
  }

  void fetchProducts() async {
    try {
      setState(() {
        isLoading = true;
      });

      // int currentSkip = (page - 1) * limit;

      // Call the API to fetch products with pagination
      ProductData productData = await ProductApi.fetchProducts(
        limit,
        skip,
      );

      setState(() {
        productList = productData.products;
        // if (skip == 0) {
        //   productList =
        //       productData.products; // Replace the list with fetched products
        // } else {
        //   productList.addAll(productData
        //       .products); // Append fetched products to the existing list
        // }
        isLoading = false;

        if (productData.products.length < limit) {
          hasMoreData = false; // Check if there are more products to fetch
        }
      });
      // for (var product in productList) {
      //   print(product.thumbnail);
      // }
    } catch (e) {
      print('Failed to fetch products: $e');
    }
  }

  void loadMoreProducts() {
    if (!isLoading && hasMoreData) {
      setState(() {
        page++;
      });
      fetchProducts();
    }
  }

  Widget buildLoadMoreButton() {
    double height = 30.0;
    return Container(
        height: height,
        //color: Colors.green,
        alignment: Alignment.center,
        // padding: EdgeInsets.all(16.0),
        child: Center(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            separatorBuilder: (context, index) => const SizedBox(
              width: 10,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                setState(() {
                  skip = index * 10;
                  selectedIndex = index;
                });
                //print(skip);
                fetchProducts();
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selectedIndex == index
                      ? bgColorprimary.withOpacity(0.7)
                      : Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
                height: height,
                width: height,
                child: Text('${index + 1}'),
              ),
            ),
          ),
        )
        // ElevatedButton(
        //   style: ElevatedButton.styleFrom(backgroundColor: bgColorprimary),
        //   onPressed: isLoading ? null : loadMoreProducts,
        //   child: isLoading ? CircularProgressIndicator() : Text('Load More'),
        // ),
        );
  }

  Widget buildDownloadButton() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          downloadCSV();
        },
        child: Text('Download CSV', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  // Widget buildThumbnailImage(String imageUrl) {
  //   return InkWell(
  //     onTap: () {
  //       showDialog(
  //         context: context,
  //         builder: (context) {
  //           return Dialog(
  //             child: Image.network(imageUrl),
  //           );
  //         },
  //       );
  //     },
  //     child: Image.network(
  //       imageUrl,
  //       width: 40,
  //       height: 40,
  //     ),
  //   );
  // }

  // Future<void> downloadCSV() async {
  //   List<List<dynamic>> csvData = [];
  //   var prodData = await ProductApi.fetchProducts(100, 0);
  //   productList = prodData.products;

  //   // Add table header
  //   csvData.add([
  //     'ID',
  //     'Title',
  //     'Description',
  //     'Price',
  //     'Rating',
  //     'Stock',
  //     'Brand',
  //     'Category',
  //   ]);

  //   // Add product rows
  //   for (var product in productList) {
  //     csvData.add([
  //       product.id,
  //       product.title,
  //       product.description,
  //       product.price,
  //       product.rating ?? '-',
  //       product.stock,
  //       product.brand,
  //       product.category,
  //     ]);
  //   }

  //   // Generate CSV string
  //   String csvString = const ListToCsvConverter().convert(csvData);
  //   //print(csvString);

  //   // Get the document directory path
  //   final directory = await getExternalStorageDirectory();
  //   //print(directory);
  //   // final directory = await getExternalStorageDirectory();
  //   filePath = '${directory!.path}/products.csv';
  //   //print(filePath);

  //   // Create the CSV file
  //   final file = File(filePath!);
  //   await file.writeAsString(csvString);

  //   // Open the CSV file using open_file package
  //   final result = await OpenFile.open(filePath!);

  //   if (result.type == ResultType.done) {
  //     // ignore: use_build_context_synchronously
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text(
  //           'CSV File Donwloaded',
  //         ),
  //       ),
  //     );
  //   } else {
  //     print('Could not open the CSV file');
  //   }
  // }
  // Future<void> downloadCSV() async {
  //   List<List<dynamic>> csvData = [];
  //   var prodData = await ProductApi.fetchProducts(100, 0);
  //   productList = prodData.products;

  //   // Add table header
  //   csvData.add([
  //     'ID',
  //     'Title',
  //     'Description',
  //     'Price',
  //     'Rating',
  //     'Stock',
  //     'Brand',
  //     'Category',
  //   ]);

  //   // Add product rows
  //   for (var product in productList) {
  //     csvData.add([
  //       product.id,
  //       product.title,
  //       product.description,
  //       product.price,
  //       product.rating ?? '-',
  //       product.stock,
  //       product.brand,
  //       product.category,
  //     ]);
  //   }

  //   // Generate CSV string
  //   String csvString = const ListToCsvConverter().convert(csvData);

  //   // Get the document directory path
  //   final directory = await getExternalStorageDirectory();
  //   filePath = '${directory!.path}/products.csv';

  //   // Create the CSV file
  //   final file = File(filePath!);
  //   await file.writeAsString(csvString);

  //   // Show success message to the user
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text('CSV file downloaded successfully'),
  //     ),
  //   );
  // }
  Future<void> downloadCSV() async {
    List<List<dynamic>> csvData = [];
    var prodData = await ProductApi.fetchProducts(100, 0);
    productList = prodData.products;

    // Add table header
    csvData.add([
      'ID',
      'Title',
      'Description',
      'Price',
      'Rating',
      'Stock',
      'Brand',
      'Category',
    ]);

    // Add product rows
    for (var product in productList) {
      csvData.add([
        product.id,
        product.title,
        product.description,
        product.price,
        product.rating ?? '-',
        product.stock,
        product.brand,
        product.category,
      ]);
    }

    // Generate CSV string
    String csvString = const ListToCsvConverter().convert(csvData);

    // Get the document directory path
    final directory = await getExternalStorageDirectory();
    filePath = '${directory!.path}/products.csv';

    // Create the CSV file
    final file = File(filePath!);
    await file.writeAsString(csvString);

    // Show success message with file path to the user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('CSV file downloaded successfully. File Path: $filePath'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [
          isdonwloading
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    child: CircularProgressIndicator(
                      color: bgColorSecondary,
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () async {
                    setState(() {
                      isdonwloading = true;
                    });
                    await Future.delayed(const Duration(seconds: 4));
                    await downloadCSV();
                    setState(() {
                      isdonwloading = false;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.download),
                  ),
                )
        ],
        backgroundColor: bgColorprimary,
      ),
      body: Column(
        children: [
          isLoading
              ? const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Expanded(
                  child: ListView(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          dataRowMinHeight: 60.0,
                          dataRowMaxHeight: 60.0,
                          columns: const [
                            DataColumn(label: Text('ID')),
                            DataColumn(label: Text('Title')),
                            DataColumn(label: Text('Thumbnail')),
                            DataColumn(label: Text('Description')),
                            DataColumn(label: Text('Price')),
                            DataColumn(label: Text('Rating')),
                            DataColumn(label: Text('Stock')),
                            DataColumn(label: Text('Brand')),
                            DataColumn(label: Text('Category')),
                          ],
                          rows: productList.map((product) {
                            return DataRow(cells: [
                              DataCell(
                                Text(
                                  product.id.toString(),
                                ),
                              ),
                              DataCell(Text(product.title)),
                              DataCell(
                                Container(
                                  width: 120,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        product.thumbnail,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(Text(product.description)),
                              DataCell(Text(product.price.toString())),
                              DataCell(Text(product.rating?.toString() ?? '-')),
                              DataCell(Text(product.stock.toString())),
                              DataCell(
                                Text(product.brand),
                              ),
                              DataCell(
                                Text(product.category),
                              ),
                            ]);
                          }).toList(),
                        ),
                      ),

                      //buildDownloadButton(),
                    ],
                  ),
                ),
          const SizedBox(
            height: 10,
          ),
          buildLoadMoreButton(),
        ],
      ),
    );
  }
}
