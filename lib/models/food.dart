  
class Food {
  String name;
  int price;
  String image;
  Food();
  Food.fromMap(Map<String, dynamic> data) {
    name = data['name'];
    price = data['price'];
    image = data['image'];
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'int': price,
      'image': image,
    };
  }
}