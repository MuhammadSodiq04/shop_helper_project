import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_helper_project/cubit/product_cubit.dart';

class ProductsList extends StatelessWidget {
  const ProductsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          leading: IconButton(
            icon:
                const Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "Products",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w700, fontSize: 23),
          ),
        ),
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductGetState) {
              if (state.products.isEmpty) {
                return const Center(
                  child: Text('No data available'),
                );
              }
              return ListView.builder(
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return Dismissible(
                    key: Key(product.id.toString()),
                    onDismissed: (direction) {
                      context.read<ProductCubit>().deleteProduct(product.id!);
                    },
                    child: ListTile(
                      title: Text(product.name),
                      subtitle: Text(product.code),
                      trailing: Text(product.count.toString()),
                    ),
                  );
                },
              );
            } else if (state is ProductLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return const Center(
                child: Text('An error occurred or an unknown state.'),
              );
            }
          },
        ));
  }
}
