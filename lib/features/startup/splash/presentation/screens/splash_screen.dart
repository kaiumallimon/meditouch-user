// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hive/hive.dart';
// import 'package:meditouch/common/repository/hive_repository.dart';
// import 'package:meditouch/features/startup/splash/logics/splash_bloc.dart';
// import 'package:meditouch/common/widgets/gradient_bg.dart';

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Trigger to start the splash logic
//     BlocProvider.of<SplashBloc>(context).add(SplashStartedEvent());

//     // Hide the status bar
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

//     // Get the theme
//     final theme = Theme.of(context).colorScheme;

//     // Build the UI
//     return Scaffold(
//       body: BlocListener<SplashBloc, SplashState>(
//         listener: (context, state) async {
//           // Get the Hive repository instance
//           final hiveRepository = HiveRepository();
//           final userInfo = await hiveRepository.getUserInfo();

//           // Check the state
//           if (state is SplashLoadedState) {
//             if (userInfo != null &&
//                 userInfo.containsKey('id') &&
//                 (userInfo['id']?.toString().isNotEmpty ?? false)) {
//               // User is logged in, navigate to Dashboard
//               Navigator.of(context).pushNamed('/dashboard');
//             } else if (await getWelcomePageWatched()) {
//               // Welcome page watched, navigate to Login
//               Navigator.of(context).pushNamed('/login');
//             } else {
//               // First time user, navigate to Welcome
//               Navigator.of(context).pushNamed('/welcome');
//             }
//           }
//         },
//         child: Stack(
//           children: [
//             // Gradient background for the splash screen
//             const GradientBackground(),

//             // Center logo image
//             Positioned(
//               left: 0,
//               right: 0,
//               top: 0,
//               bottom: 0,
//               child: Image.asset(
//                 'assets/images/logo2.png',
//                 scale: 2,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Get the welcome page watched or not flag
//   Future<bool> getWelcomePageWatched() async {
//     final settingsBox = await Hive.openBox('settings');
//     return settingsBox.get('watchedWelcomePage', defaultValue: false);
//   }
// }
