import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tasks/main.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

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
//Api Functions

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
//List for storing prodcuts

//List<Product> productList = [];

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> productList = [];
  //this list is for search
  List<Product> filteredProdcuts = [];
  //creating a controller the textfiled
  TextEditingController searchController = TextEditingController();
  String? filePath;
  int page = 1;
  int limit = 10;
  int skip = 0; // Initial skip value
  bool isLoading = false;
  bool hasMoreData = true;
  int selectedIndex = 0;
  bool isdonwloading = false;
  bool isSearchEmpty = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
    filteredProdcuts = productList;
    searchController.addListener(onSearchTextChanged); // Load initial data
  }

  //for textxxt functions
  void onSearchTextChanged() {
    if (searchController.text.isEmpty) {
      isSearchEmpty = true;
      filteredProdcuts = productList;
    } else {
      isSearchEmpty = false;
      String searchText = searchController.text.toLowerCase();
      filteredProdcuts = productList.where((product) {
        return product.title.toLowerCase().contains(searchText) ||
            product.category.toLowerCase().contains(searchText) ||
            product.brand.toLowerCase().contains(searchText);
      }).toList();
    }
    setState(() {
      // Update the filteredProducts list
      filteredProdcuts = List<Product>.from(filteredProdcuts);
    });
  }

//for fetching the products init
  void fetchProducts() async {
    try {
      setState(() {
        isLoading = true;
      });
      ProductData productData = await ProductApi.fetchProducts(
        limit,
        skip,
      );

      setState(() {
        productList = productData.products;
        filteredProdcuts = productList;

        isLoading = false;

        if (filteredProdcuts.length < limit) {
          hasMoreData = false; // Check if there are more products to fetch
        }
      });
    } catch (e) {
      print('Failed to fetch products: $e');
    }
  }

//loding more data
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
        ));
  }

  Widget buildDownloadButton() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          downloadCSV();
        },
        child:
            const Text('Download CSV', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  //csv download funtions
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
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.download),
                  ),
                )
        ],
        backgroundColor: bgColorprimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              cursorColor: bgColorprimary,
              decoration: InputDecoration(
                hintText: 'Search with Title',
                hintStyle: TextStyle(color: bgColorprimary),
                prefixIcon: GestureDetector(
                  onTap: () {
                    onSearchTextChanged();
                  },
                  child: Icon(
                    Icons.search,
                    color: bgColorprimary,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color:
                        bgColorprimary, // Replace with your desired focus color
                  ),
                ),
              ),
              onChanged: (value) {
                // Handle search logic here
                onSearchTextChanged();
              },
            ),
          ),
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
                          rows: filteredProdcuts.map((product) {
                            return DataRow(cells: [
                              DataCell(
                                Text(
                                  product.id.toString(),
                                ),
                              ),
                              DataCell(Text(product.title)),
                              DataCell(
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        fullscreenDialog: true,
                                        builder: (context) => Container(
                                          color: Colors.white,
                                          child: ImagePopup(
                                            imageUrls: product.images,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
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

//For Imagespop
class ImagePopup extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const ImagePopup({super.key, required this.imageUrls, this.initialIndex = 0});

  @override
  // ignore: library_private_types_in_public_api
  _ImagePopupState createState() => _ImagePopupState();
}

class _ImagePopupState extends State<ImagePopup> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    _currentIndex = widget.initialIndex;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPreviousImage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentIndex--;
      });
    }
  }

  void _goToNextImage() {
    if (_currentIndex < widget.imageUrls.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFirstImage = _currentIndex == 0;
    final isLastImage = _currentIndex == widget.imageUrls.length - 1;

    return Dialog(
      backgroundColor: Colors.white,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.60,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: widget.imageUrls.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.imageUrls[index]),
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!isFirstImage)
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                        onPressed: _goToPreviousImage,
                      ),
                    if (!isLastImage)
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                        ),
                        onPressed: _goToNextImage,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
