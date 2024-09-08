import 'package:brik_mobile_test/controller/product_controller.dart';

import 'package:brik_mobile_test/controller/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brik_mobile_test/view/listproduct.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(); // Load the .env file
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product App',
      home: BlocProvider(
        create: (context) => ProductBloc(ProductRepository()),
        child: const ListProductPage(),
      ),
    );
  }
}
