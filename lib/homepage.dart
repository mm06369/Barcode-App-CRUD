import 'package:barcode_app/database_helper.dart';
import 'package:barcode_app/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_sdk/flutter_barcode_sdk.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
  // String? code;
  bool addPressed = false;
  bool deletePressed = false;
  bool updatePressed = false;
  bool addBtnLoading = false;
  bool showProducts = false;
  bool productsLoading = false;
  bool showProductDetail = false;
  bool productDetailLoading = false;
  bool showUpdate = false;
  bool updateLoading = false;
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _barcodeNumberController = TextEditingController();
  TextEditingController _costController = TextEditingController();
  TextEditingController _stockController = TextEditingController();
  TextEditingController barcodeController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  

  void clearControllers() {
  _productNameController.clear();
  _barcodeNumberController.clear();
  _costController.clear();
  _stockController.clear();
}

List<ProductModel> products = [];
ProductModel product_ = ProductModel(productName: '', barcodeNumber: '', stock: 0, price: 0.0);

fetchAllProducts() async {
  setState(() {
    productsLoading = true;
  });
  List<ProductModel> products = await DatabaseHelper().fetchAllProducts();
  setState(() {
    this.products = products;
    showProducts = true;
    productsLoading = false;
  });
}

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double size = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Barcode Scanner App',
            style: TextStyle(color: Colors.white),
          ),
          flexibleSpace: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: const LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
          )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (width < 500) ? mobileProductButton() : productButton(),
          const SizedBox(height: 20),
          addPressed ? addProductForm(_productNameController, _barcodeNumberController, _costController, _stockController, _formKey): const SizedBox.shrink(),
          const SizedBox(height: 10,),
                    if (productsLoading) const Center(child: CircularProgressIndicator(color: Colors.blue,)), 
          if (showProducts) productsTable(products),
          if (showProducts) hideButton(),
          const SizedBox(height: 10,),
          if (deletePressed) enterBarcode(),
          const SizedBox(height: 20),
          if (showProductDetail && deletePressed) showProductDetailfunc(product_),
          if (productDetailLoading) const Center(child: CircularProgressIndicator(color: Colors.blue,)), 
          if (updatePressed) enterBarcode(),
          if (showUpdate && updatePressed) updateProductForm(product_, _productNameController, _barcodeNumberController, _costController, _stockController, _formKey, context)
          // Center(child: ElevatedButton(
          //   style: ButtonStyle(
          //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          //       RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(10),
          //       )
          //     ),
          //     fixedSize: MaterialStateProperty.all(const Size(200, 50))),

          //   onPressed: (){
          //     // _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
          //     //             context: context,
          //     //             onCode: (code) {
          //     //               setState(() {
          //     //                 this.code = code;
          //     //               });
          //     //             });
          //   },
          //   child: const Text("Scan Barcode", style: TextStyle(fontSize: 22),)))
        ],
      ),
    );
  }

  Widget mobileProductButton() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              addPressed = !addPressed;
              deletePressed = false;
              updatePressed = false;
               showProducts = false;
            });
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.blue, 
            onPrimary: Colors.white, 
            fixedSize: Size(150, 50),
          ),
          child: const Text('Add Product'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            setState(() {
              deletePressed = !deletePressed;
              updatePressed = false;
              addPressed = false;
              showProducts = false;
            });
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.blue, 
            onPrimary: Colors.white, 
            fixedSize: Size(150, 50),
          ),
          child: const Text('Delete Product'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            setState(() {
              updatePressed = !updatePressed;
              deletePressed = false;
              showProducts = false;
              addPressed = false;
              
            });
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            onPrimary: Colors.white,
            fixedSize: Size(150, 50),
          ),
          child: const Text('Update Product'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            fetchAllProducts();
            deletePressed = false;
            updatePressed = false;
            addPressed = false;
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.blue, 
            onPrimary: Colors.white, 
            fixedSize: Size(150, 50),
          ),
          child: const Text('Show Products'),
        ),
        const SizedBox(height: 10),
      ],
    );
  }


  Widget productButton() {
    Size btnSize = const Size(150, 50);
    const double spaceBtwBtns = 50;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            setState(() {
              addPressed = !addPressed;
              deletePressed = false;
              updatePressed = false;
              showProducts = false;
            });
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.blue, 
            onPrimary: Colors.white, 
            fixedSize: btnSize,
          ),
          child: const Text('Add Product'),
        ),
        const SizedBox(width: spaceBtwBtns),
        ElevatedButton(
          onPressed: () {
            setState(() {
              deletePressed = !deletePressed;
              updatePressed = false;
              addPressed = false;
              showProducts = false;
            });
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.blue, 
            onPrimary: Colors.white, 
            fixedSize: btnSize,
          ),
          child: const Text('Delete Product'),
        ),
        const SizedBox(width: spaceBtwBtns),
        ElevatedButton(
          onPressed: () {
            setState(() {
              updatePressed = !updatePressed;
              deletePressed = false;
              showProducts = false;
              addPressed = false;
              
            });
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            onPrimary: Colors.white,
            fixedSize: btnSize,
          ),
          child: const Text('Update Product'),
        ),
        const SizedBox(width: spaceBtwBtns),
        ElevatedButton(
          onPressed: () {
            fetchAllProducts();
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.blue, 
            onPrimary: Colors.white, 
            fixedSize: btnSize,
          ),
          child: const Text('Show Products'),
        ),
        const SizedBox(width: spaceBtwBtns),
      ],
    );
  }

  Widget addProductForm(_productNameController, _barcodeNumberController,
      _costController, _stockController, _formKey) {
    return Column(
      children: [
        SizedBox(
          width: 500,
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          controller: _productNameController,
                          decoration: const InputDecoration(
                            labelText: 'Product Name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter product name';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextFormField(
                          controller: _barcodeNumberController,
                          decoration: const InputDecoration(
                            labelText: 'Barcode Number',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter barcode number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _costController,
                    decoration: const InputDecoration(
                      labelText: 'Cost',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter cost';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _stockController,
                    decoration: const InputDecoration(
                      labelText: 'Stock',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter stock';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10,),
        ElevatedButton(
          onPressed: () async {
            setState(() {
              addBtnLoading = true;
            });
            ProductModel product = ProductModel(productName: _productNameController.text, barcodeNumber: _barcodeNumberController.text, stock: int.parse(_stockController.text), price: double.parse(_costController.text));
            final res = await DatabaseHelper().addProductToDatabase(product);
            SnackBar snackBar = SnackBar(content: Text(res ? 'Product added successfully' : 'Error adding product'));
            if (context.mounted){
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            setState(() {
              addBtnLoading = false;
              if (res){
                addPressed = false;
              }
              clearControllers();
            });
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.blue, 
            onPrimary: Colors.white, 
            fixedSize: const Size(150, 50),
          ),
          child: addBtnLoading ? const SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(color: Colors.white,)) : const Text('Add'),
        ),
        const SizedBox(height: 10,)
      ],
    );
  }


  Widget productsTable(List products) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Product Name')),
            DataColumn(label: Text('Barcode Number')),
            DataColumn(label: Text('Stock')),
            DataColumn(label: Text('Price')),
          ],
          rows: products.map((product) => DataRow(cells: [
                DataCell(Text(product.productName)),
                DataCell(Text(product.barcodeNumber)),
                DataCell(Text(product.stock.toString())),
                DataCell(Text('\Rs.${product.price.toStringAsFixed(2)}')),
              ])).toList(),
        ),
      );
  }

  Widget hideButton(){
    return ElevatedButton(
      onPressed: () {
        setState(() {
          showProducts = false;
          products = [];
        });
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.blue, 
        onPrimary: Colors.white, 
        fixedSize: const Size(150, 50),
      ),
      child: const Text('Hide'),
    );
  }

  Widget enterBarcode(){
    double width = MediaQuery.of(context).size.width;
    return (width < 600) ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                child: TextField(
                  controller: barcodeController,
                  decoration: InputDecoration(
                    hintText: "Enter Barcode Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () async  {
                  if (deletePressed){
                  setState(() {
                    productDetailLoading = true;
                  });
                  ProductModel? product = await DatabaseHelper().searchProductInDatabase(barcodeController.text);
                  if (product != null) {
                    setState(() {
                      productDetailLoading = false;
                      product_ = product;
                      showProductDetail = true;
                    });
                  } else {
                    setState(() {
                      productDetailLoading = false;
                    
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product not found')));
                  }
                  }
                  if (updatePressed){
                    setState(() {
                    productDetailLoading = true;
                  });
                  ProductModel? product = await DatabaseHelper().searchProductInDatabase(barcodeController.text);
                  if (product != null) {
                    setState(() {
                      productDetailLoading = false;
                      product_ = product;
                      showUpdate = true;
                    });
                  } else {
                    setState(() {
                      productDetailLoading = false;
                    
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product not found')));
                  }
                  }
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
                  fixedSize: MaterialStateProperty.all(const Size(90, 50)),
                ),
                child: const Text(
                  "Search",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ) : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                child: TextField(
                  controller: barcodeController,
                  decoration: InputDecoration(
                    hintText: "Enter Barcode Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () async  {
                  if (deletePressed){
                  setState(() {
                    productDetailLoading = true;
                  });
                  ProductModel? product = await DatabaseHelper().searchProductInDatabase(barcodeController.text);
                  if (product != null) {
                    setState(() {
                      productDetailLoading = false;
                      product_ = product;
                      showProductDetail = true;
                    });
                  } else {
                    setState(() {
                      productDetailLoading = false;
                    
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product not found')));
                  }
                  }
                  if (updatePressed){
                    setState(() {
                    productDetailLoading = true;
                  });
                  ProductModel? product = await DatabaseHelper().searchProductInDatabase(barcodeController.text);
                  if (product != null) {
                    setState(() {
                      productDetailLoading = false;
                      product_ = product;
                      showUpdate = true;
                    });
                  } else {
                    setState(() {
                      productDetailLoading = false;
                    
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product not found')));
                  }
                  }
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
                  fixedSize: MaterialStateProperty.all(const Size(90, 50)),
                ),
                child: const Text(
                  "Search",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              )
            ],
          );
  }

  Widget showProductDetailfunc(ProductModel product){
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Product Name: ${product.productName}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("Barcode Number: ${product.barcodeNumber}", style: TextStyle(fontSize: 16)),
          SizedBox(height: 8),
          Text("Stock: ${product.stock}", style: TextStyle(fontSize: 16)),
          SizedBox(height: 8),
          Text("Price: \$${product.price.toStringAsFixed(2)}", style: TextStyle(fontSize: 16)),
          ElevatedButton(onPressed: () async {
            final res = await DatabaseHelper().deleteProductfromDatabase(product.barcodeNumber);
            if (res){
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product deleted successfully')));
              setState(() {
                showProductDetail = false;
                deletePressed = false;
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error deleting product')));
            
            }
          }, style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)), child: const Text("Delete", style: TextStyle(color: Colors.white),),),
          const SizedBox(height: 10,),
          IconButton(onPressed: (){
            setState(() {
              deletePressed = false;
              showProductDetail = false;  
            });
          }, icon: Icon(Icons.close, color: Colors.black,))
        ],
      ),
    );
  }

  Widget updateProductForm(ProductModel product, _productNameController, _barcodeNumberController,
      _costController, _stockController, _formKey, context) {
    // Initialize the text controllers with existing product data
    _productNameController.text = product.productName;
    _barcodeNumberController.text = product.barcodeNumber;
    _costController.text = product.price.toString();
    _stockController.text = product.stock.toString();

    return Column(
      children: [
        SizedBox(
          width: 500,
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          controller: _productNameController,
                          decoration: const InputDecoration(
                            labelText: 'Product Name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter product name';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextFormField(
                          controller: _barcodeNumberController,
                          decoration: const InputDecoration(
                            labelText: 'Barcode Number',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter barcode number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _costController,
                    decoration: const InputDecoration(
                      labelText: 'Cost',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter cost';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _stockController,
                    decoration: const InputDecoration(
                      labelText: 'Stock',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter stock';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10,),
        ElevatedButton(
          onPressed: () async {
            // Here, update the product instead of adding a new one
            setState(() {
              updateLoading = true;
            });
            ProductModel updatedProduct = ProductModel(
              productName: _productNameController.text,
              barcodeNumber: _barcodeNumberController.text,
              stock: int.parse(_stockController.text),
              price: double.parse(_costController.text)
            );
            // Assume DatabaseHelper has an updateProductToDatabase method
            final res = await DatabaseHelper().updateProductToDatabase(updatedProduct);
            setState(() {
              updateLoading = false;
              if (res){
                showUpdate = false;
                updatePressed = false;
              }
              clearControllers();
            });
            SnackBar snackBar = SnackBar(content: Text(res ? 'Product updated successfully' : 'Error updating product'));
            if (context.mounted){
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.blue, 
            onPrimary: Colors.white, 
            fixedSize: const Size(150, 50),
          ),
          child: updateLoading ? SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(color: Colors.white,)) : const Text('Update'),
        ),
        const SizedBox(height: 10,)
      ],
    );
  }

}
