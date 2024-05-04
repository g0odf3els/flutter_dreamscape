import 'package:flutter_dreamscape/data/auth/auth.dart';
import 'package:flutter_dreamscape/data/collection/collection_repository.dart';
import 'package:flutter_dreamscape/data/image/image.dart';
import 'package:flutter_dreamscape/data/user/user.dart';
import 'package:flutter_dreamscape/domain/repository/auth_repository_abstract.dart';
import 'package:flutter_dreamscape/domain/repository/collection_repository_abstract.dart';
import 'package:flutter_dreamscape/domain/repository/image_repository_abstract.dart';
import 'package:flutter_dreamscape/domain/repository/user_repository_abstract.dart';
import 'package:flutter_dreamscape/domain/usecase/collection/append_image_to_collection.dart';
import 'package:flutter_dreamscape/domain/usecase/collection/create_collection.dart';
import 'package:flutter_dreamscape/domain/usecase/collection/get_paged_user_collection_list.dart';
import 'package:flutter_dreamscape/domain/usecase/collection/remove_image_from_collection.dart';
import 'package:flutter_dreamscape/domain/usecase/image/get_image.dart';
import 'package:flutter_dreamscape/domain/usecase/image/get_paged_image_list.dart';
import 'package:flutter_dreamscape/domain/usecase/image/get_paged_similar_image_list.dart';
import 'package:flutter_dreamscape/domain/usecase/user/get_user.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<AuthRepositoryAbstract>(() => AuthRepository());
  sl.registerLazySingleton<UserRepostiryAbstract>(() => UserRepository());
  sl.registerLazySingleton<ImageRepositoryAbstract>(() => ImageRepository());
  sl.registerLazySingleton<CollectionRepositoryAbstract>(
      () => CollectionRepository());

  sl.registerLazySingleton(() => GetImage(imageRepository: sl()));
  sl.registerLazySingleton(() => GetPagedImageList(imageRepository: sl()));
  sl.registerLazySingleton(
      () => GetPagedSimilarImageList(imageRepository: sl()));
  sl.registerLazySingleton(
      () => GetPagedUserCollectionList(collectionRepository: sl()));
  sl.registerLazySingleton(
      () => AppendImageToCollection(collectionRepository: sl()));
  sl.registerLazySingleton(
      () => RemoveImageFromCollection(collectionRepository: sl()));
  sl.registerLazySingleton(() => CreateCollection(collectionRepository: sl()));
  sl.registerLazySingleton(() => GetUser(userRepository: sl()));
}
