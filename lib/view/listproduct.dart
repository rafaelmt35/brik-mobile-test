import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controller/product_controller.dart';
import '../model/product_model.dart';
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
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  List<Product> allProducts = [];
  List<Product> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _searchController.addListener(() {
      setState(() {
        searchQuery = _searchController.text;
        filteredProducts = _filterProducts(allProducts, searchQuery);
      });
    });
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

  List<Product> _filterProducts(List<Product> products, String query) {
    if (query.isEmpty) {
      return products;
    }
    final lowerQuery = query.toLowerCase();
    return products.where((product) {
      final nameMatch = product.name.toLowerCase().contains(lowerQuery);
      final categoryMatch =
          product.categoryName.toLowerCase().contains(lowerQuery);
      return nameMatch || categoryMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text('List Products'),
        actions: [
          IconButton(
            onPressed: () {
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
            allProducts = products; // Store the complete list
            filteredProducts = _filterProducts(allProducts, searchQuery);
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        focusColor: Colors.amber,
                        labelText: 'Search Products by Name or Category',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        suffixIcon: const Icon(Icons.search),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
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
                          visible: currentPage > 1,
                          child: ElevatedButton(
                            onPressed: _goToPreviousPage,
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Colors.orange;
                                  }
                                  return Colors.amberAccent;
                                },
                              ),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                              ),
                            ),
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
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Colors.orange;
                                  }
                                  return Colors.amberAccent;
                                },
                              ),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all(
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
