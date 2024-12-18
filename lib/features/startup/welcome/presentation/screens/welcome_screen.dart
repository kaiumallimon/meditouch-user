import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/common/widgets/widget_motion.dart';
import 'package:meditouch/features/startup/welcome/logics/welcome_cubit.dart';
import 'package:meditouch/features/startup/welcome/presentation/widgets/textstyles.dart';
import 'package:meditouch/features/startup/welcome/presentation/widgets/welcome_next_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../../common/widgets/gradient_bg.dart';
import '../widgets/welcome_log_reg_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  List<Map<String, String>> onboardSlogans = [
    {
      "image": "assets/images/welcome-1.png",
      "title": "Healthcare at your fingertips, no matter where you are",
      "subtitle":
      "Connecting rural communities to expert doctors-panel through seamless video consultations and affordable care.",
    },
    {
      "image": "assets/images/welcome-2.png",
      "title": "Bringing Quality Care Closer to Home",
      "subtitle":
      "Empowering you with easy access to medical services, medications, and emergency support from anywhere.",
    },
    {
      "image": "assets/images/welcome-3.png",
      "title": "Affordable, Accessible Anytime Healthcare",
      "subtitle":
      "Transforming healthcare with cost-friendly solutions and real-time medical support for all.",
    }
  ];

  late ValueNotifier<int> currentIndexNotifier;

  @override
  void initState() {
    super.initState();
    final bloc = BlocProvider.of<WelcomeCubit>(context);
    currentIndexNotifier = ValueNotifier(bloc.state);

    // Listen to Bloc state changes and update the notifier
    bloc.stream.listen((state) {
      currentIndexNotifier.value = state;
    });
  }

  @override
  void dispose() {
    currentIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    // Retain status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // Set status bar and navigation colors
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: theme.surface,
      systemNavigationBarColor: theme.surface,
      statusBarIconBrightness: theme.brightness,
      systemNavigationBarIconBrightness: theme.brightness,
    ));

    final bloc = BlocProvider.of<WelcomeCubit>(context);

    final screenSize = MediaQuery.of(context).size;
    final height = screenSize.height;
    final width = screenSize.width;

    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder<int>(
          valueListenable: currentIndexNotifier,
          builder: (context, state, _) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05,
                vertical: height * 0.02,
              ),
              child: Column(
                children: [
                  WidgetMotion(
                    key: ValueKey('image-$state'),
                    direction: 'right',
                    child: SizedBox(
                      height: height * 0.5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Stack(
                          children: [
                            const GradientBackground(),
                            Center(
                              child: Image.asset(
                                onboardSlogans[state]['image']!,
                                scale: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  WidgetMotion(
                    key: ValueKey('title-$state'),
                    direction: 'left',
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                      child: Text(
                        onboardSlogans[state]['title']!,
                        textAlign: TextAlign.center,
                        style: getTitleStyle(theme.onSurface),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  WidgetMotion(
                    key: ValueKey('subtitle-$state'),
                    direction: 'left',
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                      child: Text(
                        onboardSlogans[state]['subtitle']!,
                        textAlign: TextAlign.center,
                        style: getParagraphStyle(theme.onSurface),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.04),
                  if (state != 2)
                    WidgetMotion(
                      key: ValueKey('button-$state'),
                      direction: 'up',
                      child: WelcomeNextButton(
                        size: Size(width * 0.5, height * 0.06),
                        color: theme.primary,
                        textColor: theme.onPrimary,
                        text: 'Continue',
                        onPressed: () {
                          bloc.next();
                        },
                      ),
                    ),
                  if (state == 2)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        2,
                            (index) {
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.02),
                              child: WidgetMotion(
                                key: ValueKey('button-$state-$index'),
                                direction: index == 0 ? 'left' : 'right',
                                child: WelcomeButton(
                                  hasBorder: index != 0,
                                  size: Size(double.infinity, height * 0.06),
                                  color: index == 0
                                      ? theme.primary
                                      : theme.surface,
                                  textColor: index == 0
                                      ? theme.onPrimary
                                      : theme.onSurface,
                                  text: index == 0 ? 'Register' : 'Login',
                                  onPressed: () {
                                    if (index == 0) {
                                      Navigator.of(context)
                                          .pushReplacementNamed('/register');
                                    } else {
                                      Navigator.of(context)
                                          .pushReplacementNamed('/login');
                                    }

                                    setWelcomePageWatched();
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void setWelcomePageWatched() async {
    var settingsBox = await Hive.openBox('settings');
    await settingsBox.put('watchedWelcomePage', true);
    print('Saved');
  }
}
