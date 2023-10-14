import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_helper_project/cubit/product_repository.dart';
import 'package:shop_helper_project/model/product_model.dart';
import 'package:shop_helper_project/model/universal_data.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit({required this.productRepository}) : super(ProductInitial());

  final ProductRepository productRepository;

  getAllProduct() async {
    emit(ProductLoadingState());
    UniversalData universalData = await productRepository.getAllProduct();
    if(universalData.data != null) {
      emit(ProductGetState(products: universalData.data));
    }else{
      emit(ProductErrorState(error: "Product null"));
    }
  }

  addProduct(ProductModel product) async {
    emit(ProductLoadingState());
    await productRepository.addProduct(product);
    emit(ProductAddState());
  }

  updateProduct(ProductModel product) async {
    emit(ProductLoadingState());
    await productRepository.updateProduct(product);
    emit(ProductUpdateState());
  }

  deleteProduct(int productId) async {
    emit(ProductLoadingState());
    await productRepository.deleteProduct(productId);
    emit(ProductDeleteState());
  }
}
