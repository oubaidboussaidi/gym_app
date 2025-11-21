import "package:get_it/get_it.dart";
import "package:gym_app/services/auth.dart";
import "package:gym_app/services/theme.dart";
import "package:gym_app/view_models/auth_model.dart";
import "package:gym_app/view_models/login_model.dart";

final GetIt serviceLocator = GetIt.instance;

void setupLocator() {
  serviceLocator.registerLazySingleton<AuthService>(() => AuthService());
  serviceLocator.registerLazySingleton<ThemeService>(() => ThemeService());

  serviceLocator.registerFactory(
    () => LoginViewModel(serviceLocator<AuthService>()),
  );

  serviceLocator.registerFactory(
    () => AuthViewModel(serviceLocator<AuthService>()),
  );
}
