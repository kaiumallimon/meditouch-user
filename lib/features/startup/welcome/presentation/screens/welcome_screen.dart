import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meditouch/features/startup/welcome/logics/welcome_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../../common/widgets/gradient_bg.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  List<Map<String, String>> onboardSlogans = [
    {
      "svg": "assets/svg/00d34e8d.svg",
      "title": "Healthcare at Your Fingertips,\nNo Matter Where You Are",
      "subtitle":
          "Connecting rural communities to expert doctors-panel through seamless video consultations and affordable care.",
    },
    {
      "svg": "assets/svg/2d7c0ad1.svg",
      "title": "Bringing Quality Care Closer to Home",
      "subtitle":
          "Empowering you with easy access to medical services, medications, and emergency support from anywhere.",
    },
    {
      "svg": "assets/svg/ab5e821d.svg",
      "title": "Affordable, Accessible\nAnytime Healthcare",
      "subtitle":
          "Transforming healthcare with cost-friendly solutions and real-time medical support for all.",
    }
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    // pageview controller
    final pageController = PageController();

    // retain status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // set statusbar and navigation colors
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      body: Stack(
        children: [
          // gradient background
          const GradientBackground(),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: onboardSlogans.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              onboardSlogans[index]['title']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              height: height * .1,
                            ),
                            SvgPicture.asset(
                              onboardSlogans[index]['svg']!,
                              height: height * .3,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(
                              height: height * .08,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                onboardSlogans[index]['subtitle']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            if (index == onboardSlogans.length - 1) // Last page
                              Container(
                                height: 50,
                                margin: const EdgeInsets.only(top: 30),
                                width: width * .7,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    setWelcomePageWatched();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.primary,
                                    foregroundColor: theme.onPrimary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text('Get Started'),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                    onPageChanged: (pageIndex) {
                      // Update the page index in the bloc
                      context.read<WelcomeBloc>().add(UpdatePage(pageIndex));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: BlocBuilder<WelcomeBloc, WelcomeState>(
                    builder: (context, state) {
                      if (state is WelcomeInitial) {
                        return SmoothPageIndicator(
                          controller: pageController,
                          count: onboardSlogans.length,
                          effect: ExpandingDotsEffect(
                            activeDotColor: Colors.white,
                            dotColor: Colors.white.withOpacity(0.3),
                            dotHeight: 5,
                            dotWidth: 5,
                            expansionFactor: 5,
                            spacing: 10,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // mark the welcome screen as viewed by the user
  void setWelcomePageWatched() async {
    var settingsBox = await Hive.openBox('settings');
    await settingsBox.put('watchedWelcomePage', true); // Store the flag
    print('Saved');
  }

  // get the welcome page watched or not flag
  Future<bool> getWelcomePageWatched()async{
    var settingsBox = await Hive.openBox('settings');
    return await settingsBox.get('watchedWelcomePage',defaultValue: false);
  }
}
