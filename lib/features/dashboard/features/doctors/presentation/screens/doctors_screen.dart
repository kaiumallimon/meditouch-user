import 'package:flutter/services.dart';
import 'package:meditouch/app/app_exporter.dart';
import 'package:meditouch/features/dashboard/features/doctors/logics/doctors_bloc.dart';
import 'package:meditouch/features/dashboard/features/doctors/logics/doctors_state.dart';

import '../../logics/doctors_event.dart';

class DoctorsScreen extends StatelessWidget {
  const DoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // get theme
    final theme = Theme.of(context).colorScheme;

    // set status bar and nav themes
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: theme.surfaceContainer,
      statusBarIconBrightness: theme.brightness,
      systemNavigationBarColor: Color.alphaBlend(
        theme.primary.withOpacity(0.08), // Tint effect
        theme.surface,
      ),
      systemNavigationBarIconBrightness: theme.brightness,
    ));

    // fetch doctors
    context.read<DoctorsBloc>().add(DoctorsEventFetch());

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.surfaceContainer,
        appBar: AppBar(
          elevation: 0,
          surfaceTintColor: theme.surfaceContainer,
          title: const Text('Doctors',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          backgroundColor: theme.surfaceContainer,
          toolbarHeight: 70,
        ),
        body: buildDoctorsBody(context, theme),
      ),
    );
  }

  Widget buildDoctorsBody(BuildContext context, ColorScheme theme) {
    return BlocBuilder<DoctorsBloc, DoctorsState>(
      builder: (context, state) {
        if (state is DoctorsStateLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is DoctorsStateSuccess) {
          final specializations = state.doctors
              .map((doctor) => doctor.specialization)
              .toSet()
              .toList();
          return DefaultTabController(
            length: specializations.length,
            child: Column(
              children: [
                TabBar(
                  isScrollable: true,
                  dividerColor: theme.primary.withOpacity(.1),
                  tabs: specializations
                      .map((specialization) => Tab(
                            text: specialization,
                          ))
                      .toList(),
                ),
                Expanded(
                  child: TabBarView(
                    children: specializations.map((specialization) {
                      final filteredDoctors = state.doctors
                          .where((doctor) =>
                              doctor.specialization == specialization)
                          .toList();
                      return buildDoctorsList(filteredDoctors);
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        }

        if (state is DoctorsStateFailure) {
          return Center(child: Text(state.message));
        }

        return const SizedBox();
      },
    );
  }

  Widget buildDoctorsList(List<dynamic> doctors) {
    return ListView.builder(
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        final doctor = doctors[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(doctor.imageUrl),
          ),
          title: Text(doctor.name),
          subtitle: Text(doctor.specialization),
        );
      },
    );
  }
}
