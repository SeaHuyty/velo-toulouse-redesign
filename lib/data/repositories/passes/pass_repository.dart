import 'package:velo_toulouse_redesign/data/models/pass.dart';

abstract class PassRepository {
  Future<List<PassModel>> getAvailablePasses();

  Future<PassModel?> getPassById(String passId);

}