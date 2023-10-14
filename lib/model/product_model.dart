class ProductModelFields {
  static const String id = '_id';
  static const String name = '_name';
  static const String count = '_count';
  static const String code = '_code';

  static const String tableName = 'products';
}

class ProductModel{
  int? id;
  final String name;
  final int count;
  final String code;

  ProductModel(
      {this.id,
        required this.name,
        required this.count,
        required this.code});

  ProductModel copyWith({
    int? id,
    String? name,
    int? count,
    String? code,
    }) =>
      ProductModel(
        id: id ?? this.id,
          name : name ?? this.name,
          count: count ?? this.count,
          code: code ?? this.code,
          );

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json[ProductModelFields.id],
    name: json[ProductModelFields.name] as String? ?? '',
    count: json[ProductModelFields.count] as int? ?? 0,
    code: json[ProductModelFields.code] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    ProductModelFields.name: name,
    ProductModelFields.count: count,
    ProductModelFields.code: code,
  };
}