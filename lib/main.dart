import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_helper_project/cubit/product_cubit.dart';
import 'package:shop_helper_project/cubit/product_repository.dart';
import 'package:shop_helper_project/cubit/scan/qr_cubit.dart';
import 'package:shop_helper_project/ui/qr_scanner_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App(productRepository: ProductRepository(),));
}


class App extends StatelessWidget {
 const App({super.key,required this.productRepository});

  final ProductRepository productRepository;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<QRViewCubit>(create: (context) => QRViewCubit()),
        BlocProvider<ProductCubit>(create: (context) => ProductCubit(productRepository: productRepository)..getAllProduct()),
      ],
      child: const MainApp(),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: QRViewExample()
    );
  }
}
