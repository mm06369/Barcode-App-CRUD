class ProductModel {
  String productName;
  String barcodeNumber;
  int stock;
  double price;

  ProductModel({
    required this.productName,
    required this.barcodeNumber,
    required this.stock,
    required this.price,
  });

  // Method to convert the product details to a JSON format
  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'barcodeNumber': barcodeNumber,
      'stock': stock,
      'price': price,
    };
  }

  // Method to create a ProductModel from JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productName: json['productName'],
      barcodeNumber: json['barcodeNumber'],
      stock: json['stock'],
      price: json['price'],
    );
  }
}