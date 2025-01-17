import 'package:meditouch/app/app_exporter.dart';
import 'package:meditouch/features/dashboard/features/community/presentation/screens/community_screen.dart';
import 'package:meditouch/features/dashboard/features/emergency/presentation/screen/emergency_screen.dart';
import 'package:meditouch/features/dashboard/features/healthtips/presentation/screen/healthtips_screen.dart';
import 'package:meditouch/features/dashboard/features/nurses/presentation/screens/nurse_screen.dart';

import '../../widgets/home_grid_item.dart';

Widget buildHomeGridMenu(BuildContext context, ColorScheme theme) {
  return SizedBox(
    height: 240,
    child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: [
          HomeGridItem(
            title: 'Doctors',
            icon: Image.asset(
              'assets/icons/doctor-flaticon.png',
              width: 25,
              height: 25,
            ),
            onTap: () {
              // go to doctors screen:
              Navigator.of(context).pushNamed('/doctors');
            },
            backgroundColor: theme.primaryContainer,
            textColor: theme.onSurface,
          ),
          HomeGridItem(
            title: 'Health News',
            icon: Image.asset(
              'assets/icons/news-report.png',
              width: 25,
              height: 25,
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UserHealthTipsPage(),
                ),
              );
            },
            backgroundColor: theme.primaryContainer,
            textColor: theme.onSurface,
          ),
          HomeGridItem(
            title: 'Medications',
            icon: Image.asset(
              'assets/icons/drugs.png',
              width: 25,
              height: 25,
            ),
            onTap: () {
              // Navigator.of(context).pushNamed(Routes.appointment);
            },
            backgroundColor: theme.primaryContainer,
            textColor: theme.onSurface,
          ),
          HomeGridItem(
            title: 'Hire Nurse',
            icon: Image.asset(
              'assets/icons/nurse.png',
              width: 25,
              height: 25,
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => HireNursePage(),
                ),
              );
            },
            backgroundColor: theme.primaryContainer,
            textColor: theme.onSurface,
          ),
          HomeGridItem(
            title: 'Emergency',
            icon: Image.asset(
              'assets/icons/ambulance-flaticon.png',
              width: 25,
              height: 25,
            ),
            onTap: () async {
              final Map<String, dynamic>? user =
                  await HiveRepository().getUserInfo();
              final userId = user!['id'];

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EmergencyPage(userId: userId),
                ),
              );
            },
            backgroundColor: theme.primaryContainer,
            textColor: theme.onSurface,
          ),
          HomeGridItem(
            title: 'Community',
            icon: Image.asset(
              'assets/icons/partners.png',
              width: 25,
              height: 25,
            ),
            onTap: () {
              // Navigator.of(context).pushNamed(Routes.appointment);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CommunityScreen(),
                ),
              );
            },
            backgroundColor: theme.primaryContainer,
            textColor: theme.onSurface,
          ),
        ]),
  );
}
