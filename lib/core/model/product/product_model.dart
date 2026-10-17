
class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String categoryId;
  final List<String> images;
  final bool isTrending;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.images,
    required this.isTrending,
  });

  factory ProductModel.fromFirestore(
    String id,
    Map<String, dynamic> json,
  ) {
    return ProductModel(
      id: id,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      categoryId: json['categoryId'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      isTrending: json['isTrending'] ?? false,
    );
  }
}
