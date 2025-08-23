import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shop/pages/auth_or_home.dart';
import 'package:shop/pages/authentication.dart';
import 'package:shop/pages/cart.dart';
import 'package:shop/pages/orders.dart';
import 'package:shop/pages/product_form.dart';
import 'package:shop/pages/products_page.dart';
import 'package:shop/provider/auth.dart';
import 'package:shop/provider/cart.dart';
import 'package:shop/pages/product_detail.dart';
import 'package:shop/pages/products_overview.dart';
import 'package:shop/provider/order_list.dart';
import 'package:shop/provider/product_list.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (_) => ProductList('', []),
          update: (context, auth, previous) =>
              ProductList(auth.token ?? '', previous?.items ?? []),
        ),

        ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (_) => OrderList('', []),
          update: (context, auth, previous) =>
              OrderList(auth.token ?? '', previous?.items ?? []),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'Lato',
          primarySwatch: Colors.purple,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.purple,
            secondary: Colors.deepOrange,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            elevation: 4,
          ),
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => AuthOrHomePage(),
          '/login': (context) => AuthenticationPage(),
          '/home': (context) => ProductsOverviewPage(),
          '/product-detail': (context) => ProductDetailPage(),
          '/cart': (context) => CartPage(),
          '/orders': (context) => OrdersPage(),
          '/products': (context) => ProductsPage(),
          '/product_form': (context) => ProductFormPage(),
        },
      ),
    );
  }
}
