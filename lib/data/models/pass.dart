
import 'user_model.dart';

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

  bool isActiveFor(UserModel user) {
    return user.activePassId == id;
  }
}
