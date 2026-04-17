

class PassModel {
  final String id;
  final String title;
  final double price;
  final String duration; 

  PassModel({
    required this.id,
    required this.title,
    required this.price,
    required this.duration,
  });

  factory PassModel.fromMap(String id, Map<String, dynamic> data) {
    return PassModel(
      id: id,
      title: data['title'] as String,
      price: data['price'] as double,
      duration: data['duration'] as String,
    );
  }
}
