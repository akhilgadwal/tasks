part of 'products_cubit.dart';

class ProductsState extends Equatable {
  final List<Product> allProducts;
  final List<Product> filterProducts;
  final bool isloading;
  final String message;
  final List<String> cat;
  const ProductsState({
    this.filterProducts = const [],
    this.isloading = false,
    this.message = '',
    this.cat = const [],
    this.allProducts = const [],
  });

  ProductsState copyWith({
    List<Product>? filterProducts,
    List<Product>? allProducts,
    bool? isloading,
    String? message,
    List<String>? cat,
  }) {
    return ProductsState(
        filterProducts: filterProducts ?? this.filterProducts,
        isloading: isloading ?? this.isloading,
        message: message ?? this.message,
        cat: cat ?? this.cat,
        allProducts: allProducts ?? this.allProducts);
  }

  @override
  List<Object> get props => [allProducts, isloading, message, cat];
}
















// abstract class ProductsState extends Equatable {
//   const ProductsState();

//   @override
//   List<Object> get props => [];
// }

// class ProductsInitial extends ProductsState {}

// class ProductsLoading extends ProductsState {}

// class ProductsResponse extends ProductsState {
//   List<Product> products;
//   ProductsResponse(this.products);
// }

// class ProductsError extends ProductsState {
//   final String message;
//   ProductsError(this.message);
// }
