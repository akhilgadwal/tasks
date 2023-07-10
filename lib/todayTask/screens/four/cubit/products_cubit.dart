import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tasks/todayTask/model/product.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  //creating the instance from the model
  //final ProductApi _productApi;
  ProductsCubit() : super(const ProductsState());

  //calling the api
  Future<void> fetchProducts() async {
    emit(state.copyWith(isloading: true));
    try {
      final response = await ProductApi.fetchProducts();
      List<String> cats = response.products.map((e) => e.category).toList();
      //new list
      cats.insert(0, 'clear');
      List<String> sortedCats = cats.toSet().toList();
      //new emit
      emit(state.copyWith(
          allProducts: response.products, isloading: false, cat: sortedCats));
    } catch (e) {
      emit(state.copyWith(message: e.toString(), isloading: false));
    }
  }

  void onSearchChanged(String catSelected) {
    String selectedText =
        catSelected == 'clear' ? '' : catSelected.toLowerCase();
    emit(state.copyWith(isloading: true));

    List<Product> filteredProdcuts = state.allProducts.where((product) {
      return product.category.toLowerCase().contains(selectedText);
    }).toList();
    emit(state.copyWith(filterProducts: filteredProdcuts, isloading: false));
    print(filteredProdcuts.first.brand);
  }
}
