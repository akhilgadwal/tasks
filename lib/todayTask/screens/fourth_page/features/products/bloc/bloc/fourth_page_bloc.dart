import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

import '../../../../../../model/product.dart';

part 'fourth_page_event.dart';
part 'fourth_page_state.dart';

class FourthPageBloc extends Bloc<FourthPageEvent, FourthPageState> {
  FourthPageBloc() : super(FourthPageInitial()) {
    on<ProductsInitEvent>(productsInitEvent);
  }

  Future<List<Product>> productsInitEvent(
      ProductsInitEvent event, Emitter<FourthPageState> emit) async {
    emit(PostLoadingState());
    try {
      List<Product> products = [];
      final response =
          await http.get(Uri.parse('https://dummyjson.com/products?limit=100'));
      var data = jsonDecode(response.body);
      //print(data);
      if (response.statusCode == 200) {
        var productData = ProductData.fromJson(data);
        // print(data); // Create ProductData object
        products = productData.products; // Add productData to the products list
        emit(PostFetchingSuccessfulState(products: products));
        // print(data);
        return products;
      } else {
        throw Exception('Failed to fetch products');
      }
    } catch (error) {
      throw error;
    }
  }
}
