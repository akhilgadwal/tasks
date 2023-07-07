import 'package:flutter/material.dart';
import 'package:tasks/todayTask/screens/fourth_page/features/products/bloc/bloc/fourth_page_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:tasks/todayTask/screens/pages/loginpages/page3.dart';[[[]]]

class ProductPages extends StatefulWidget {
  const ProductPages({super.key});

  @override
  State<ProductPages> createState() => _ProductPagesState();
}

class _ProductPagesState extends State<ProductPages> {
  //creating instance of it
  final FourthPageBloc fourthPageBloc = FourthPageBloc();
  //initstate
  @override
  void initState() {
    fourthPageBloc.add(ProductsInitEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'All Products',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer(
        bloc: fourthPageBloc,
        listenWhen: (previous, current) => current is ProductActionState,
        buildWhen: (previous, current) => current is! ProductActionState,
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case PostLoadingState:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case PostFetchingSuccessfulState:
              final successState = state as PostFetchingSuccessfulState;
              return GridView.builder(
                padding: const EdgeInsets.all(6),
                itemCount: successState.products.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  childAspectRatio: 0.9,
                  maxCrossAxisExtent: 300,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemBuilder: (context, index) {
                  final product = successState.products[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                //color: Colors.amber,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(4))),
                            height: 120,
                            width: 200,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8)),
                              child: Image.network(
                                product.images[0],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            product.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text('₹ ${product.price}')
                          // Display other product information as needed
                        ],
                      ),
                    ),
                  );
                },
              );
            // Container(
            //   child: ListView.builder(
            //     itemCount: successState.products.length,
            //     itemBuilder: (context, index) {
            //       return Column(
            //         children: [
            //           Text(successState.products[index].title),
            //         ],
            //       );
            //     },
            //   ),
            // );
            default:
              return Container(); // or return null, depending on your requirement
          }
        },
      ),
    );
  }
}
