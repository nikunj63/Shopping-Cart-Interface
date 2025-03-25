import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopping_cart/Models/ProductModel.dart';

// Events
abstract class CartEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddToCart extends CartEvent {
  final Product product;
  AddToCart(this.product);
}

class RemoveFromCart extends CartEvent {
  final Product product;
  RemoveFromCart(this.product);
}

class ClearCart extends CartEvent {}

// State
abstract class CartState extends Equatable {
  @override
  List<Object> get props => [];
}

class CartUpdated extends CartState {
  final List<Product> cartItems;
  CartUpdated(this.cartItems);

  @override
  List<Object> get props => [cartItems]; //  Ensures state comparison works
}

// Bloc
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartUpdated([])) {
    on<AddToCart>(_addToCart);
    on<RemoveFromCart>(_removeFromCart);
    on<ClearCart>(_clearCart);
  }

  void _addToCart(AddToCart event, Emitter<CartState> emit) {
    final List<Product> updatedCart = List.from((state as CartUpdated).cartItems);

    int index = updatedCart.indexWhere((item) => item.id == event.product.id);

    if (index != -1) {
      // Increase quantity if product already in cart
      updatedCart[index] = updatedCart[index].copyWith(quantity: updatedCart[index].quantity + 1);
    } else {
      //  Add new product with quantity = 1
      updatedCart.add(event.product.copyWith(quantity: 1));
    }

    emit(CartUpdated(updatedCart));
  }

  void _removeFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    final List<Product> updatedCart = List.from((state as CartUpdated).cartItems);

    int index = updatedCart.indexWhere((item) => item.id == event.product.id);

    if (index != -1) {
      if (updatedCart[index].quantity > 1) {
        updatedCart[index] = updatedCart[index].copyWith(quantity: updatedCart[index].quantity - 1);
      } else {
        updatedCart.removeAt(index);
      }
    }

    emit(CartUpdated(updatedCart));
  }

  void _clearCart(ClearCart event, Emitter<CartState> emit) {
    emit(CartUpdated([]));
  }
}
