class Product {
  final int id;
  final String name;
  final String description;
  final int price;
  final String image;
  const Product({required this.id,required this.name, required this.description, required this.price,required this.image});
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['title'],
      image:json['images'][0],
      description:json['description'],
      price:json['price'],
    );
  }
}