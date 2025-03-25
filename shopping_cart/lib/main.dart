import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_cart/Bloc/cart_bloc.dart';
import 'package:shopping_cart/Bloc/productBloc.dart';
import 'package:shopping_cart/Screens/productScreen.dart';
import 'package:shopping_cart/Services/apiServices.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartBloc>(create: (context) => CartBloc()),
        BlocProvider(create: (context) => ProductBloc(apiService: ApiService())..add(FetchProducts())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ProductScreen(),
      ),
    );
  }
}
