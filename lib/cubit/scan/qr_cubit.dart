import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';
import 'package:shop_helper_project/local_db/local_database.dart';
import 'package:shop_helper_project/model/product_model.dart';
import 'package:shop_helper_project/model/universal_data.dart';
import 'package:shop_helper_project/utils/global_dialog.dart';

class QRViewCubit extends Cubit<QRViewCubitState> {
  QRViewCubit() : super(QRViewCubitState.initial());

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  void onPermissionSet(QRViewController controller,BuildContext context,bool p) {
    context.read<QRViewCubit>().controller = controller;

    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  Future<void> checkIfQRCodeExists(String qrCode, BuildContext context,Barcode result) async {
    final UniversalData existingProducts = await LocalDatabase.getAllProduct();
    ProductModel? existingProduct;
    for (var product in existingProducts.data) {
      if (product.code == qrCode) {
        existingProduct = product;
        break;
      }
    }
    if (existingProduct != null && context.mounted) {
      showProductAlertDialog(
          context: context,
          result: result,
          title: "Select",
          onTap: () {
            Navigator.pop(context);
            showProductAlertDialog(
                context: context,
                result: result,
                buttonText: "Buy",
                title: "Buy Product",
                productModel: existingProduct);
          },
          onTap2: () {
            Navigator.pop(context);
            showProductAlertDialog(
                context: context,
                result: result,
                buttonText: "Sal",
                title: "Sale Product",
                productModel: existingProduct);
          });
    } else {
      showProductAlertDialog(
          result: result, context: context, title: "Add Product");
    }
  }

  void onQRViewCreated(QRViewController controller, BuildContext context) {
    controller.scannedDataStream.listen((scanData) async {
      final qrCode = scanData.code;
      final existingProducts = await LocalDatabase.getAllProduct();
      ProductModel? existingProduct;

      for (var product in existingProducts.data) {
        if (product.code == qrCode) {
          existingProduct = product;
          break;
        }
      }

      if (existingProduct != null) {
        emit(QRViewCubitState.scanned(scanData, existingProduct));
      } else {
        emit(QRViewCubitState.scanned(scanData, null));
      }
    });
  }
}

class QRViewCubitState {
  final Barcode? result;
  final ProductModel? existingProduct;

  QRViewCubitState(this.result, this.existingProduct);

  factory QRViewCubitState.initial() => QRViewCubitState(null, null);

  factory QRViewCubitState.scanned(Barcode result, ProductModel? existingProduct) =>
      QRViewCubitState(result, existingProduct);
}
