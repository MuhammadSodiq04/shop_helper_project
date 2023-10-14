import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shop_helper_project/cubit/product_cubit.dart';
import 'package:shop_helper_project/cubit/scan/qr_cubit.dart';
import 'package:shop_helper_project/ui/products_list.dart';

class QRViewExample extends StatelessWidget {
  const QRViewExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildQrView(context),
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                color: Colors.white,
                child: BlocBuilder<QRViewCubit, QRViewCubitState>(
                  builder: (context, state) {
                    return Text(
                      state.result != null ? state.result!.code.toString() : "Scan a code",
                      style: const TextStyle(fontSize: 18),
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () async {
                    final cubit = context.read<QRViewCubit>();
                    // cubit.onQRViewCreated(cubit.controller!, context);
                    cubit.controller?.toggleFlash();
                  },
                  child: const Icon(
                    Icons.flashlight_on_rounded,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 60, right: 60),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 60,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {
                    final cubit = context.read<QRViewCubit>();
                    if (cubit.state.result?.code != null) {
                      cubit.checkIfQRCodeExists(
                      cubit.state.result!.code.toString(), context,cubit.state.result!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Scan empty!",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Center(child: Text("Save")),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 60, left: 60),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                height: 60,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {
                    context.read<ProductCubit>().getAllProduct();
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return const ProductsList();
                    }));
                  },
                  child: const Center(child: Text("Products")),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return QRView(
      key: context.read<QRViewCubit>().qrKey,
      onQRViewCreated: (controller) {
        context.read<QRViewCubit>().onQRViewCreated(controller, context);
      },
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) {
        context.read<QRViewCubit>().onPermissionSet(ctrl, context, p);
      },
    );
  }
}

extension WidgetListDivide on List<Widget> {
  List<Widget> divide(Widget divider) {
    List<Widget> dividedList = [];
    for (int i = 0; i < length; i++) {
      dividedList.add(this[i]);
      if (i < length - 1) {
        dividedList.add(divider);
      }
    }
    return dividedList;
  }
}
