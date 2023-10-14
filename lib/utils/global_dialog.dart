import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shop_helper_project/local_db/local_database.dart';
import 'package:shop_helper_project/model/product_model.dart';
import 'package:shop_helper_project/ui/qr_scanner_screen.dart';

void showProductAlertDialog(
    {required BuildContext context,
      required String title,
      required Barcode result,
      VoidCallback? onTap,
      VoidCallback? onTap2,
      String buttonText = '',
      ProductModel? productModel}) {
  TextEditingController nameController = TextEditingController();
  TextEditingController countController = TextEditingController();
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Container(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Theme.of(context).scaffoldBackgroundColor),
          child: title != "Select"?Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              title == "Add Product"
                  ? Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextField(
                keyboardType: TextInputType.name,
                controller: nameController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    hintText: "Product Name",
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(10),
                    ),
                ),
              ),
                  )
                  : const SizedBox(),
              TextField(
                keyboardType: TextInputType.number,
                controller: countController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: "Product Count",
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel')),
                  ElevatedButton(
                      onPressed: () {
                        if (productModel != null) {
                          if (countController.text.isNotEmpty && productModel.count-int.parse(countController.text)>=0 || buttonText=="Buy") {
                            updateProduct(productModel.copyWith(
                                code: productModel.code,
                                name: productModel.name,
                                count: buttonText=="Buy"?productModel.count+int.parse(countController.text):productModel.count-int.parse(countController.text)));
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Product ${"${buttonText}ed"}!",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Count empty or no product!",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } else {
                          if (nameController.text.isNotEmpty &&
                              countController.text.isNotEmpty) {
                            saveProduct(
                                result.code.toString(),
                                nameController.text,
                                int.parse(countController.text));
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Product added!",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Name or count empty!",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      child: Text(buttonText=="Buy"?buttonText:title == "Add Product"?"Add":"${buttonText}e")),
                ],
              )
            ].divide(const SizedBox(
              height: 20,
            )),
          ):
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(onPressed: onTap2, child: const Text("Sale")),
              ElevatedButton(onPressed: onTap, child: const Text("Take")),
            ],
          ),
        ),
        contentPadding: EdgeInsets.zero,
      );
    },
  );
}

void saveProduct(String barcode, String name, int count) async {
  final product = ProductModel(code: barcode, count: count, name: name);
  await LocalDatabase.insertProduct(product);
}

void updateProduct(ProductModel productModel) async {
  await LocalDatabase.updateProduct(productModel: productModel);
}