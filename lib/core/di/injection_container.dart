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
import '../../features/verification/data/repositories/verification_repository_impl.dart';
import '../../features/verification/domain/repositories/verification_repository.dart';
import '../../features/verification/domain/usecases/submit_verification.dart';
import '../../features/verification/presentation/provider/verification_provider.dart'; // Contains your VerificationCubit

// Listings Imports
import '../../features/listings/data/datasources/listings_remote_datasource.dart';
import '../../features/listings/data/repositories/listings_repository_impl.dart';
import '../../features/listings/domain/repositories/listings_repository.dart';
import '../../features/listings/presentation/provider/listings_provider.dart';

// Chat Imports
import '../../features/chat/data/datasources/chat_remote_datasource.dart';
import '../../features/chat/data/repositories/chat_repository_impl.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/chat/presentation/provider/chat_bloc.dart';

// Home Imports
import '../../features/home/home_injection.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // --- CORE SYSTEM LAYER ---
  // Register Core ApiClient/Dio instance first so features can fetch it immediately
  sl.registerLazySingleton(() => ApiClient());

  // --- FEATURES SLICES ---
  
  // 0. HOME MODULE
  initHome(); 

  // 1. AUTHENTICATION MODULE
  sl.registerFactory(() => AuthProvider(sl()));
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton(() => AuthRemoteDataSource(sl()));

  // 2. IDENTITY VERIFICATION MODULE
  // FIXED: Changed to register your Bloc/Cubit controller type cleanly
  sl.registerFactory(() => VerificationCubit(submitVerification: sl())); 
  sl.registerLazySingleton(() => SubmitVerification(sl()));
  sl.registerLazySingleton<VerificationRepository>(
    () => VerificationRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<VerificationRemoteDataSource>(
    () => VerificationRemoteDataSourceImpl(dio: sl<ApiClient>().dio), // Or simply sl<ApiClient>() depending on your architecture setup
  );

  // 3. MARKETPLACE LISTINGS MODULE
  sl.registerFactory(() => ListingsProvider());
  sl.registerLazySingleton<ListingsRepository>(() => ListingsRepositoryImpl(sl()));
  sl.registerLazySingleton(() => ListingsRemoteDataSource(sl()));

  // 4. CHAT SYSTEM FEATURE MODULE
  // FIXED: Structured parameter keys mapping safely to remote dependencies
  sl.registerFactory(() => ChatBloc(repository: sl()));
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<ChatRemoteDataSource>(() => ChatRemoteDataSourceImpl());
}