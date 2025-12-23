import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:booster/core/config/amplify_config.dart';
import 'package:booster/core/theme/app_theme.dart';
import 'package:booster/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/general_info/presentation/pages/welcome_page.dart';
import 'features/layout/main_layout_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es');
  await dotenv.load(fileName: ".env");
  await di.init();
  await configureAmplify();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider(
          create: (context) => di.sl<AuthBloc>()..add(AppStarted()),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Booster',
            theme: AppTheme.lightTheme,
            themeMode: ThemeMode.system,
            home: const AuthWrapper(),
            // onGenerateRoute: AppRoutes.onGenerateRoute,
          ),
        );
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading || state is AuthInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is Authenticated) {
          return const MainLayoutPage();
        } else {
          return const WelcomePage();
        }
      },
    );
  }
}
