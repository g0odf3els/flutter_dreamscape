import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dreamscape/core/error/failure.dart';
import 'package:flutter_dreamscape/core/usecase/usecase.dart';
import 'package:flutter_dreamscape/data/user/models/user.dart';
import 'package:flutter_dreamscape/domain/repository/user_repository_abstract.dart';

class GetUser implements UseCase<User, ParamsGetUser> {
  final UserRepostiryAbstract userRepository;

  GetUser({required this.userRepository});

  @override
  Future<Either<Failure, User>> call(ParamsGetUser params) async {
    return await userRepository.getUser(params.id);
  }
}

class ParamsGetUser extends Equatable {
  final String id;

  const ParamsGetUser({required this.id});

  @override
  List<Object> get props => [id];

  @override
  String toString() {
    return 'ParamsGetUser{user: $id}';
  }
}
