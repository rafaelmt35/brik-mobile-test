import 'package:flutter/material.dart';

import '../model/product_model.dart';

class DetailProductPage extends StatelessWidget {
  final Product product;

  const DetailProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: Colors.amberAccent,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                        image: NetworkImage(product.image),
                        fit: BoxFit.contain)),
              ),
              Text('Product name: ${product.name}'),
              Text('id: ${product.id}'),
              Text('SKU: ${product.sku}'),
              Text('Category id: ${product.categoryId}'),
              Text('Category name: ${product.categoryName}'),
              Text('Harga: Rp${product.harga}'),
              Text('Weight: ${product.weight} g'),
              Text('Width: ${product.width} cm'),
              Text('Length: ${product.length} cm'),
              Text('height: ${product.height} cm'),
            ],
          ),
        ),
      ),
    );
  }
}
