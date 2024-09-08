import 'package:bloc/bloc.dart';
import 'package:brik_mobile_test/controller/repository.dart';
// ignore: unused_import
import '../controller/product_controller.dart';
import '../model/product_model.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;
  List<Product> allProducts = [];

  ProductBloc(this.repository) : super(ProductInitial()) {
    on<LoadProductsEvent>(_onLoadProductsEvent);
  }

  Future<void> _onLoadProductsEvent(
      LoadProductsEvent event, Emitter<ProductState> emit) async {
    // Fetch products if empty
    if (allProducts.isEmpty) {
      try {
        allProducts = await repository.fetchAllProducts();
      } catch (e) {
        emit(ProductError(errorMessage: e.toString()));
        return;
      }
    }

    // Calc pagination
    final startIndex = (event.page - 1) * event.limit;
    final endIndex = startIndex + event.limit;

    // Get products for currnt page
    final products = allProducts.sublist(
      startIndex,
      endIndex > allProducts.length ? allProducts.length : endIndex,
    );

    emit(ProductLoaded(page: event.page, products: products));
  }
}

abstract class ProductEvent {}

class LoadProductsEvent extends ProductEvent {
  final int page;
  final int limit;

  LoadProductsEvent(this.page, this.limit);
}

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

//load products
class ProductLoaded extends ProductState {
  final int page;
  final List<Product> products;
  ProductLoaded({required this.page, required this.products});
}

//error message
class ProductError extends ProductState {
  final String errorMessage;
  ProductError({required this.errorMessage});
}
