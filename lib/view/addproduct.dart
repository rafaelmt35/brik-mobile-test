// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:brik_mobile_test/controller/repository.dart';
import 'package:brik_mobile_test/model/product_model.dart';
import 'package:flutter/material.dart';

class AddProductPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  // Controllers to manage the input data
  final TextEditingController idController = TextEditingController();
  final TextEditingController categoryIdController = TextEditingController();
  final TextEditingController categoryNameController = TextEditingController();
  final TextEditingController skuController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  ProductRepository repository = ProductRepository();

  AddProductPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.amberAccent,
          title: const Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Category ID
              TextFormField(
                controller: categoryIdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Category ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the category ID';
                  }
                  return null;
                },
              ),

              // Category Name
              TextFormField(
                controller: categoryNameController,
                decoration: const InputDecoration(labelText: 'Category Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the category name';
                  }
                  return null;
                },
              ),

              // SKU
              TextFormField(
                controller: skuController,
                decoration: const InputDecoration(labelText: 'SKU'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the product SKU';
                  }
                  return null;
                },
              ),

              // Name
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the product name';
                  }
                  return null;
                },
              ),

              // Description
              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the product description';
                  }
                  return null;
                },
              ),

              // Weight
              TextFormField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Weight (g)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the product weight';
                  }
                  return null;
                },
              ),

              // Width
              TextFormField(
                controller: widthController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Width (cm)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the product width';
                  }
                  return null;
                },
              ),

              // Length
              TextFormField(
                controller: lengthController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Length (cm)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the product length';
                  }
                  return null;
                },
              ),

              // Height
              TextFormField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Height (cm)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the product height';
                  }
                  return null;
                },
              ),

              // Image URL
              TextFormField(
                controller: imageController,
                decoration: const InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the image URL';
                  }
                  return null;
                },
              ),

              // Harga
              TextFormField(
                controller: hargaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the product price';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.orange;
                      }
                      return Colors.amberAccent;
                    },
                  ),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    List<Product> products =
                        await repository.fetchAllProducts();

                    int newId = products.isNotEmpty ? products.last.id + 1 : 1;
                    Product newProduct = Product(
                      id: newId,
                      categoryId: int.parse(categoryIdController.text),
                      categoryName: categoryNameController.text,
                      sku: skuController.text,
                      name: nameController.text,
                      description: descriptionController.text,
                      weight: int.parse(weightController.text),
                      width: int.parse(widthController.text),
                      length: int.parse(lengthController.text),
                      height: int.parse(heightController.text),
                      image: imageController.text,
                      harga: int.parse(hargaController.text),
                    );

                    repository.addProduct(newProduct);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('New Product Added'),
                          content: const Text(
                              'The product has been successfully added.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
