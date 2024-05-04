import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String? errorMessage;

  Failure([this.errorMessage]);

  @override
  List<Object?> get props => [errorMessage];

  @override
  String toString() {
    return '${runtimeType.toString()} {errorMessage: $errorMessage}';
  }
}

class ServerFailure extends Failure {
  ServerFailure([super.errorMessage]);
}

class ConnectionFailure extends Failure {
  ConnectionFailure([super.errorMessage]);
}

class StorageFailure extends Failure {
  StorageFailure([super.errorMessage]);
}
