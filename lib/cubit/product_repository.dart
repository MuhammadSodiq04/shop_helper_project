import 'package:shop_helper_project/local_db/local_database.dart';
import 'package:shop_helper_project/model/product_model.dart';
import 'package:shop_helper_project/model/universal_data.dart';

class ProductRepository{

  Future<UniversalData> getAllProduct()=>LocalDatabase.getAllProduct();
  Future<void> addProduct(ProductModel productModel)=>LocalDatabase.insertProduct(productModel);
  Future<void> deleteProduct(int id)=>LocalDatabase.deleteProduct(id);
  Future<void> updateProduct(ProductModel productModel)=>LocalDatabase.updateProduct(productModel: productModel);
}