class ProductModel {
  int id;
  String name;
  String description;
  String descriptionLong;
  int stock;
  String price;
  Category category;
  String picture;

  ProductModel();

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    descriptionLong = json['description_long'];
    stock = json['stock'];
    price = json['price'];
    category = Category.fromJson(json['category']);
    picture = json['picture'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'description_long': descriptionLong,
      'stock': stock,
      'price': price,
      'category': category.toJson(),
      'picture': picture
    };
  }
}

class Category {
  int id;
  String name;

  Category();

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
