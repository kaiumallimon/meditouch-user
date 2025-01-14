import 'app_bloc_providers.dart';
import './app_exporter.dart';

class MediTouchApp extends StatelessWidget {
  const MediTouchApp({super.key, required this.themeCubit, required this.isLoggedIn, required this.isWelcomeWatched});

  final ThemeCubit themeCubit;
  final bool isLoggedIn;
  final bool isWelcomeWatched;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: providers, // Initialize Blocs using MultiBlocProvider
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, darkMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: darkMode ? AppTheme().getDarkTheme() : AppTheme().getTheme(),

            // Use GetX's navigation and routes
            initialRoute: isLoggedIn?  "/dashboard": isWelcomeWatched  ? "/login": "/welcome",
            routes: {
              // "/": (context) => const SplashScreen(),
              "/welcome": (context) => const WelcomeScreen(),
              "/login": (context) => LoginScreen(),
              "/register": (context) => const RegisterScreen(),
              "/dashboard": (context) => DashboardScreen(),
              "/profile": (context) => ProfileScreen(),
              "/theme": (context) => const ThemeScreen(),
              "/cart": (context) => const CartScreen(),
              "/orders": (context) => const OrderScreen(),
              "/doctors": (context) => const DoctorsScreen(),
            },
          );
        },
      ),
    );
  }
}
