import 'package:booster/core/services/api_key_service.dart';
import 'package:booster/features/projects/data/datasources/projects_remote_data_source.dart';
import 'package:booster/features/records/data/datasources/records_remote_datasource.dart';
import 'package:booster/features/records/data/repositories/records_repository_impl.dart';
import 'package:booster/features/records/domain/repositories/records_repository.dart';
import 'package:booster/features/records/domain/usecases/upload_record.dart';
import 'package:booster/features/records/presentation/blocs/record_upload_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:booster/features/projects/data/repositories/projects_repository_impl.dart';
import 'package:booster/features/projects/domain/repositories/projects_repository.dart';
import 'package:booster/features/projects/domain/usecases/get_projects.dart';
import 'package:booster/features/projects/presentation/bloc/bloc.dart';
import 'package:booster/features/auth/data/datasources/api_key_remote_data_source.dart';
import 'package:booster/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:booster/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:booster/features/auth/data/repositories/api_key_repository_impl.dart';
import 'package:booster/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:booster/features/auth/domain/repositories/api_key_repository.dart';
import 'package:booster/features/auth/domain/repositories/auth_repository.dart';
import 'package:booster/features/auth/domain/usecases/confirm_reset_password.dart';
import 'package:booster/features/auth/domain/usecases/forgot_password.dart';
import 'package:booster/features/auth/domain/usecases/generate_api_key.dart';
import 'package:booster/features/auth/domain/usecases/get_current_user.dart';
import 'package:booster/features/auth/domain/usecases/sign_in.dart';
import 'package:booster/features/auth/domain/usecases/sign_out.dart';
import 'package:booster/features/auth/domain/usecases/sign_up.dart';
import 'package:booster/features/auth/domain/usecases/verify_and_set_password.dart';
import 'package:booster/features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ============================================
  // External
  // ============================================
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // HTTP Client
  sl.registerLazySingleton(() => http.Client());

  // Core Services
  sl.registerLazySingleton(() => ApiKeyService(sl()));

  // ============================================
  // Features
  // ============================================

  // Auth Feature
  _initAuth();

  // Projects Feature
  _initProjects();

  // Records Feature
  _initRecords();

  // TODO: Add other features here
  // _initDashboard();
}

void _initAuth() {
  // BLoC
  sl.registerFactory(
    () => AuthBloc(
      signIn: sl(),
      signUp: sl(),
      signOut: sl(),
      getCurrentUser: sl(),
      forgotPassword: sl(),
      confirmResetPassword: sl(),
      verifyAndSetPassword: sl(),
      generateApiKey: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => ForgotPassword(sl()));
  sl.registerLazySingleton(() => ConfirmResetPassword(sl()));
  sl.registerLazySingleton(() => VerifyAndSetPassword(sl()));
  sl.registerLazySingleton(() => GenerateApiKey(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<ApiKeyRepository>(
    () => ApiKeyRepositoryImpl(
      remoteDataSource: sl(),
      apiKeyService: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<ApiKeyRemoteDataSource>(
    () => ApiKeyRemoteDataSourceImpl(client: sl()),
  );
}

void _initProjects() {
  // BLoC
  sl.registerFactory(
    () => ProjectsBloc(
      getProjects: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetProjects(sl()));

  // Repository
  sl.registerLazySingleton<ProjectsRepository>(
    () => ProjectsRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<ProjectsRemoteDataSource>(
    () => ProjectsRemoteDataSourceImpl(
      client: sl(),
      apiKeyService: sl(),
    ),
  );
}

//init Records
void _initRecords() {
  // BLoC
  sl.registerFactory(
    () => RecordUploadBloc(
      uploadRecord: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => UploadRecord(sl()));

  // Repository
  sl.registerLazySingleton<RecordsRepository>(
    () => RecordsRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<RecordsRemoteDatasource>(
    () => RecordsRemoteDatasourceImpl(),
  );

}
