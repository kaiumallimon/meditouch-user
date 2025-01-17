import 'package:meditouch/app/app_exporter.dart';
import 'package:meditouch/features/dashboard/features/healthtips/presentation/screen/healthtips_screen.dart';

import '../../widgets/home_grid_item.dart';

Widget buildHomeGridMenu(BuildContext context, ColorScheme theme) {
  return SizedBox(
    height: 240,
    child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
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
            title: 'Appointments',
            icon: Image.asset(
              'assets/icons/doctor-flaticon.png',
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
            title: 'Appointments',
            icon: Image.asset(
              'assets/icons/doctor-flaticon.png',
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
            title: 'Appointments',
            icon: Image.asset(
              'assets/icons/doctor-flaticon.png',
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
            title: 'Appointments',
            icon: Image.asset(
              'assets/icons/doctor-flaticon.png',
              width: 25,
              height: 25,
            ),
            onTap: () {
              // Navigator.of(context).pushNamed(Routes.appointment);
            },
            backgroundColor: theme.primaryContainer,
            textColor: theme.onSurface,
          ),
        ]),
  );
}
