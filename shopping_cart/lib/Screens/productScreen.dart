import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_cart/Bloc/cart_bloc.dart';
import 'package:shopping_cart/Bloc/productBloc.dart';
import 'package:shopping_cart/Models/ProductModel.dart';
import 'package:shopping_cart/Screens/cartScreen.dart';
import 'package:shopping_cart/Screens/productDetailScreen.dart';

class ProductScreen extends StatefulWidget {
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        title: Text("Catalogue", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              int itemCount = 0;
              if (state is CartUpdated) {
                itemCount = state.cartItems.fold(0, (sum, item) => sum + item.quantity);
              }
              return IconButton(
                icon: Stack(
                  children: [
                    Icon(Icons.shopping_cart, size: 30),
                    if (itemCount > 0)
                      Positioned(
                        right: 0,
                        child: CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.pink,
                          child: Text(
                            "$itemCount",
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartScreen()),
                  );
                },
              );
            },
          ),
        ],
        backgroundColor: Colors.pink.shade50,
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            return GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => BlocProvider.value(
      value: BlocProvider.of<CartBloc>(context),
      child: ProductDetailScreen(product: product),
    ),
  ),
);

                  },
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                            child: Image.network(
                              product.thumbnail,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.title, style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(product.brand, style: TextStyle(color: Colors.grey)),
                              Row(
                                children: [
                                  Text(
                                    "₹${product.price.toStringAsFixed(2)}",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "₹${(product.price / (1 - (product.discountPercentage / 100))).toStringAsFixed(2)}",
                                    style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey),
                                  ),
                                ],
                              ),
                              Text("${product.discountPercentage}% OFF", style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                        BlocBuilder<CartBloc, CartState>(
                          builder: (context, cartState) {
                            int quantity = 0;
                            if (cartState is CartUpdated) {
                              var cartItem = cartState.cartItems.firstWhere(
                                (item) => item.id == product.id,
                                orElse: () => Product(
                                  id: -1, title: '', description: '', price: 0, discountPercentage: 0, rating: 0,
                                  stock: 0, brand: '', category: '', thumbnail: '', images: [], sku: '',
                                ),
                              );
                              quantity = cartItem.id != -1 ? cartItem.quantity : 0;
                            }

                            return Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  context.read<CartBloc>().add(AddToCart(product));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: quantity > 0 ? Colors.green : Colors.pink.shade400,
                                  foregroundColor: Colors.white,
                                ),
                                child: Text(quantity > 0 ? "Added ($quantity)" : "Add"),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("Failed to load products"));
          }
        },
      ),
    );
  }
}
