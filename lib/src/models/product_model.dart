class Product {
  Product({
    this.id,
    this.name,
    this.description,
    this.descriptionLong,
    this.stock,
    this.category,
    this.price,
    this.categoryId,
    this.picture,
    this.merchant,
    this.totalSales,
    this.status,
    this.haveMenu,
    this.menuCategories,
  });

  int id;
  String name;
  String description;
  dynamic descriptionLong;
  int stock;
  Category category;
  double price;
  int categoryId;
  dynamic picture;
  int merchant;
  int totalSales;
  Status status;
  bool haveMenu;
  List<MenuCategory> menuCategories;
}

class Category {
  Category({
    this.id,
    this.name,
    this.picture,
    this.status,
  });

  int id;
  String name;
  dynamic picture;
  Status status;
}

class Status {
  Status({
    this.id,
    this.name,
    this.slugName,
  });

  int id;
  String name;
  String slugName;
}

class MenuCategory {
  MenuCategory({
    this.id,
    this.name,
    this.isRange,
    this.isObligatory,
    this.haveQuantity,
    this.minQuantity,
    this.maxQuantity,
    this.limitOptionsChoose,
    this.minOptionsChoose,
    this.maxOptionsChoose,
    this.options,
  });

  int id;
  String name;
  bool isRange;
  bool isObligatory;
  bool haveQuantity;
  int minQuantity;
  int maxQuantity;
  int limitOptionsChoose;
  int minOptionsChoose;
  int maxOptionsChoose;
  List<Option> options;
}

class Option {
  Option({
    this.id,
    this.name,
    this.price,
  });

  int id;
  String name;
  double price;
}
