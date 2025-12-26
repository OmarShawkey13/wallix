import 'package:dio/dio.dart';
import 'package:wallix/core/network/remote/api_endpoints.dart';
import 'package:wallix/core/utils/cubit/home_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initInjections() async {
  sl.registerFactory(() => HomeCubit());

  final sharedPref = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPref);

  sl.registerLazySingleton(
    () => Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    ),
  );
}
