import 'package:get_it/get_it.dart';
import '../network/api_client.dart';

// Auth Imports
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login.dart';
import '../../features/auth/presentation/provider/auth_provider.dart';

// Verification Imports
import '../../features/verification/data/datasources/verification_remote_datasource.dart';
import '../../features/verification/presentation/provider/verification_provider.dart';

// Listings Imports
import '../../features/listings/data/datasources/listings_remote_datasource.dart';
import '../../features/listings/data/repositories/listings_repository_impl.dart';
import '../../features/listings/domain/repositories/listings_repository.dart';
import '../../features/listings/presentation/provider/listings_provider.dart';

// Chat Importsr
import '../../features/chat/data/datasources/chat_remote_datasource.dart';
import '../../features/chat/data/repositories/chat_repository_impl.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/chat/presentation/provider/chat_bloc.dart';


import '../../features/home/home_injection.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // --- FEATURES ---
initHome(); // Initialize Home feature dependencies
  // 1. AUTHENTICATION
  sl.registerFactory(() => AuthProvider(sl()));
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton(() => AuthRemoteDataSource(sl()));

  // 2. VERIFICATION
  // Use registerFactory for Providers so they reset when the screen closes
  sl.registerFactory(() => VerificationProvider(sl())); 
  sl.registerLazySingleton(() => VerificationRemoteDataSource(sl()));

  // 3. LISTINGS (Marketplace)
  sl.registerFactory(() => ListingsProvider());
 
sl.registerLazySingleton<ListingsRepository>(() => ListingsRepositoryImpl(sl()));
  sl.registerLazySingleton(() => ListingsRemoteDataSource(sl()));
// Core/DI Injection Configuration Block for the Chat Feature Module
sl.registerFactory(() => ChatBloc(repository: sl()));
sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(remoteDataSource: sl()));
sl.registerLazySingleton<ChatRemoteDataSource>(() => ChatRemoteDataSourceImpl());
  // --- CORE ---
  sl.registerLazySingleton(() => ApiClient());
}