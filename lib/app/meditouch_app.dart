import 'package:get/get.dart';
import '../features/dashboard/features/cart/presentation/screens/cart_screen.dart';
import '../features/dashboard/features/order/presentation/screens/order_screen.dart';
import 'app_bloc_providers.dart';
import './app_exporter.dart';

class MediTouchApp extends StatelessWidget {
  const MediTouchApp({super.key, required this.themeCubit});

  final ThemeCubit themeCubit;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: providers, // Initialize Blocs using MultiBlocProvider
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, darkMode) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: darkMode ? AppTheme().getDarkTheme() : AppTheme().getTheme(),

            // Use GetX's navigation and routes
            initialRoute: "/",
            getPages: [
              GetPage(name: "/", page: () => const SplashScreen()),
              GetPage(name: "/welcome", page: () => const WelcomeScreen()),
              GetPage(name: "/login", page: () => LoginScreen()),
              GetPage(name: "/register", page: () => const RegisterScreen()),
              GetPage(name: "/dashboard", page: () => DashboardScreen()),
              GetPage(name: "/profile", page: () => ProfileScreen()),
              GetPage(name: "/theme", page: () => const ThemeScreen()),
              GetPage(name: "/cart", page: () => const CartScreen()),
              GetPage(name: "/orders", page: () => const OrderScreen()),
            ],
          );
        },
      ),
    );
  }
}
