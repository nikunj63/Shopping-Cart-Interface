import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopping_cart/Models/ProductModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class LoadCart extends CartEvent {}

// States
abstract class CartState extends Equatable {
  @override
  List<Object> get props => [];
}

class CartUpdated extends CartState {
  final List<Product> cartItems;
  CartUpdated(this.cartItems);

  @override
  List<Object> get props => [cartItems];
}

// Bloc
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartUpdated([])) {
    on<AddToCart>(_addToCart);
    on<RemoveFromCart>(_removeFromCart);
    on<ClearCart>(_clearCart);
    on<LoadCart>(_loadCart);

    add(LoadCart()); // Load cart on startup
  }

  void _addToCart(AddToCart event, Emitter<CartState> emit) async {
    final List<Product> updatedCart = List.from((state as CartUpdated).cartItems);
    int index = updatedCart.indexWhere((item) => item.id == event.product.id);

    if (index != -1) {
      updatedCart[index] = updatedCart[index].copyWith(quantity: updatedCart[index].quantity + 1);
    } else {
      updatedCart.add(event.product.copyWith(quantity: 1));
    }

    emit(CartUpdated(updatedCart));
    await _saveCart(updatedCart);
  }

  void _removeFromCart(RemoveFromCart event, Emitter<CartState> emit) async {
    final List<Product> updatedCart = List.from((state as CartUpdated).cartItems);
    updatedCart.removeWhere((item) => item.id == event.product.id);

    emit(CartUpdated(updatedCart));
    await _saveCart(updatedCart);
  }

  void _clearCart(ClearCart event, Emitter<CartState> emit) async {
    emit(CartUpdated([]));
    await _saveCart([]);
  }

  Future<void> _saveCart(List<Product> cart) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('cart', jsonEncode(cart.map((e) => e.toJson()).toList()));
  }

  void _loadCart(LoadCart event, Emitter<CartState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    String? cartData = prefs.getString('cart');
    if (cartData != null) {
      List<Product> cart = (jsonDecode(cartData) as List).map((e) => Product.fromJson(e)).toList();
      emit(CartUpdated(cart));
    }
  }
}
