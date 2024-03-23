import 'package:flutter_dreamscape/repositories/user/models/models.dart';

abstract class UserRepostiryAbstract {
  Future<User> getUser(String id);
}
