part of 'product_cubit.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}
class ProductAddState extends ProductState {}
class ProductUpdateState extends ProductState {}
class ProductDeleteState extends ProductState {}
class ProductLoadingState extends ProductInitial {}
class ProductGetState extends ProductState {
  final List<ProductModel> products;

  ProductGetState({required this.products});
}
class ProductErrorState extends ProductState {
  final String error;

  ProductErrorState({required this.error});
}