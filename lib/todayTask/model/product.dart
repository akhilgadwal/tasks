//import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
  static Future<ProductData> fetchProducts(int page, int limit) async {
    final response = await http.get(
        Uri.parse('https://dummyjson.com/products?page=$page&limit=$limit'));
    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return ProductData.fromJson(data);
    } else {
      throw Exception('Failed to fetch products');
    }
  }
}
