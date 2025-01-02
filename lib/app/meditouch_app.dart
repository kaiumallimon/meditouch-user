import 'package:meditouch/app/app_bloc_providers.dart';

import '../features/dashboard/features/cart/presentation/screens/cart_screen.dart';
import '../features/dashboard/features/order/presentation/screens/order_screen.dart';
import './app_exporter.dart';

class MediTouchApp extends StatelessWidget {
  const MediTouchApp({super.key, required this.themeCubit});

  final ThemeCubit themeCubit;

  @override
  Widget build(BuildContext context) {
    // initialize the blocs using multiblocprovider
    return MultiBlocProvider(
      providers: providers,
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, darkMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: darkMode ? AppTheme().getDarkTheme() : AppTheme().getTheme(),
            // define the routes
            initialRoute: "/",
            routes: {
              "/": (context) => const SplashScreen(),
              "/welcome": (context) => const WelcomeScreen(),
              "/login": (context) => LoginScreen(),
              "/register": (context) => const RegisterScreen(),
              "/dashboard": (context) => DashboardScreen(),
              "/profile": (context) => ProfileScreen(),
              "/theme": (context) => const ThemeScreen(),
              "/cart": (context) => const CartScreen(),
              "/orders": (context) => const OrderScreen(),
            },
          );
        },
      ),
    );
  }
}
