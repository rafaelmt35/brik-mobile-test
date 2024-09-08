// ignore_for_file: library_private_types_in_public_api

import 'package:brik_mobile_test/controller/mockData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controller/product_controller.dart';
import 'addproduct.dart';
import 'details.dart';

class ListProductPage extends StatefulWidget {
  const ListProductPage({super.key});

  @override
  _ListProductPageState createState() => _ListProductPageState();
}

class _ListProductPageState extends State<ListProductPage> {
  int currentPage = 1;
  final int limit = 8; // limit products in list
  bool hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    BlocProvider.of<ProductBloc>(context)
        .add(LoadProductsEvent(currentPage, limit));
  }

  void _goToNextPage() {
    if (hasMoreData) {
      setState(() {
        currentPage++;
      });
      _loadProducts();
    }
  }

  void _goToPreviousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
      _loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Products'),
        actions: [
          IconButton(
            onPressed: () {
              // MockDataInput mockData = MockDataInput();
              // mockData.postMockData();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProductPage()),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading && currentPage == 1) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            final products = state.products;
            hasMoreData = products.length == limit;

            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  currentPage = 1; // Reset to first page
                });
                _loadProducts();
              },
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailProductPage(product: product),
                              ),
                            );
                          },
                          title: Text(product.name),
                          subtitle: Text(product.categoryName),
                          trailing: Text('Rp${product.harga}'),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Visibility(
                          visible: currentPage == 1 ? false : true,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.pressed)) {
                                    return Colors.orange;
                                  }
                                  return Colors.amberAccent;
                                },
                              ),
                              foregroundColor:
                                  WidgetStateProperty.all(Colors.white),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                              ),
                            ),
                            onPressed: _goToPreviousPage,
                            child: const Text(
                              'Previous Page',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: hasMoreData,
                          child: ElevatedButton(
                            onPressed: _goToNextPage,
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.pressed)) {
                                    return Colors.orange;
                                  }
                                  return Colors.amberAccent;
                                },
                              ),
                              foregroundColor:
                                  WidgetStateProperty.all(Colors.white),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Next Page',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ProductError) {
            return Center(child: Text(state.errorMessage));
          }
          return Container();
        },
      ),
    );
  }
}
