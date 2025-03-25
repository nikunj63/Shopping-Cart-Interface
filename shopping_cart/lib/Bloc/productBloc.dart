import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopping_cart/Models/ProductModel.dart';
import 'package:shopping_cart/Services/apiServices.dart';

// Events
abstract class ProductEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchProducts extends ProductEvent {}

// State
abstract class ProductState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  ProductLoaded(this.products);
}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}

// Bloc
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ApiService apiService;

  ProductBloc({required this.apiService}) : super(ProductLoading()) {
    on<FetchProducts>(_fetchProducts);
  }

  Future<void> _fetchProducts(
      FetchProducts event, Emitter<ProductState> emit) async {
    try {
      final products = await apiService.fetchProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
