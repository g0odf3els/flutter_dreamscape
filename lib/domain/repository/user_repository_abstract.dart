import 'package:dartz/dartz.dart';
import 'package:flutter_dreamscape/core/error/failure.dart';
import 'package:flutter_dreamscape/data/user/models/models.dart';

abstract class UserRepostiryAbstract {
  Future<Either<Failure, User>> getUser(String id);
}
