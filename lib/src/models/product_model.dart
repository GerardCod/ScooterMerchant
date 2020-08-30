class Product {
  int id;
  String name;
  String description;
  String descriptionLong;
  int stock;
  Category category;
  double price;
  int categoryId;
  String picture;
  int merchant;
  int totalSales;
  Status status;
  bool haveMenu;
  List<MenuCategories> menuCategories;

  Product(
      {this.id,
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
      this.menuCategories});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    descriptionLong = json['description_long'];
    stock = json['stock'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    price = json['price'];
    categoryId = json['category_id'];
    picture = json['picture'];
    merchant = json['merchant'];
    totalSales = json['total_sales'];
    status =
        json['status'] != null ? new Status.fromJson(json['status']) : null;
    haveMenu = json['have_menu'];
    if (json['menu_categories'] != null) {
      menuCategories = new List<MenuCategories>();
      json['menu_categories'].forEach((v) {
        menuCategories.add(new MenuCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['description_long'] = this.descriptionLong;
    data['stock'] = this.stock;
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    data['price'] = this.price;
    data['category_id'] = this.categoryId;
    data['picture'] = this.picture;
    data['merchant'] = this.merchant;
    data['total_sales'] = this.totalSales;
    if (this.status != null) {
      data['status'] = this.status.toJson();
    }
    data['have_menu'] = this.haveMenu;
    if (this.menuCategories != null) {
      data['menu_categories'] =
          this.menuCategories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  int id;
  String name;
  String picture;
  Status status;

  Category({this.id, this.name, this.picture, this.status});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    picture = json['picture'];
    status =
        json['status'] != null ? new Status.fromJson(json['status']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['picture'] = this.picture;
    if (this.status != null) {
      data['status'] = this.status.toJson();
    }
    return data;
  }
}

class Status {
  int id;
  String name;
  String slugName;

  Status({this.id, this.name, this.slugName});

  Status.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slugName = json['slug_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug_name'] = this.slugName;
    return data;
  }
}

class MenuCategories {
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
  List<Options> options;

  MenuCategories(
      {this.id,
      this.name,
      this.isRange,
      this.isObligatory,
      this.haveQuantity,
      this.minQuantity,
      this.maxQuantity,
      this.limitOptionsChoose,
      this.minOptionsChoose,
      this.maxOptionsChoose,
      this.options});

  MenuCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isRange = json['is_range'];
    isObligatory = json['is_obligatory'];
    haveQuantity = json['have_quantity'];
    minQuantity = json['min_quantity'];
    maxQuantity = json['max_quantity'];
    limitOptionsChoose = json['limit_options_choose'];
    minOptionsChoose = json['min_options_choose'];
    maxOptionsChoose = json['max_options_choose'];
    if (json['options'] != null) {
      options = new List<Options>();
      json['options'].forEach((v) {
        options.add(new Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['is_range'] = this.isRange;
    data['is_obligatory'] = this.isObligatory;
    data['have_quantity'] = this.haveQuantity;
    data['min_quantity'] = this.minQuantity;
    data['max_quantity'] = this.maxQuantity;
    data['limit_options_choose'] = this.limitOptionsChoose;
    data['min_options_choose'] = this.minOptionsChoose;
    data['max_options_choose'] = this.maxOptionsChoose;
    if (this.options != null) {
      data['options'] = this.options.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  int id;
  String name;
  double price;

  Options({this.id, this.name, this.price});

  Options.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    return data;
  }
}
