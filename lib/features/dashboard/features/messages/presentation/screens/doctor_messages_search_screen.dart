import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:meditouch/app/app_exporter.dart';
import 'package:meditouch/common/widgets/custom_loading_animation.dart';
import 'package:meditouch/features/dashboard/features/messages/logics/messages_bloc.dart';
import 'package:meditouch/features/dashboard/features/messages/presentation/screens/converation_screen.dart';

import '../../../doctors/data/models/doctor_model.dart';

class DoctorMessagesSearchScreen extends StatefulWidget {
  DoctorMessagesSearchScreen({super.key});

  @override
  State<DoctorMessagesSearchScreen> createState() =>
      _DoctorMessagesSearchScreenState();
}

class _DoctorMessagesSearchScreenState
    extends State<DoctorMessagesSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<DoctorModel> _filteredDoctors = [];
  List<DoctorModel> _allDoctors = [];

  @override
  void initState() {
    super.initState();

    // Trigger search on text change
    _searchController.addListener(() {
      _filterDoctors();
    });

    // Load all doctors initially
    context.read<MessagesSearchBloc>().add(AllDoctorsEventFetch());
  }

  void _filterDoctors() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredDoctors = _allDoctors
          .where((doctor) =>
              doctor.name.toLowerCase().contains(query) ||
              doctor.specialization.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Type a doctor name or specialization',
            hintStyle: TextStyle(color: theme.onSurface.withOpacity(.5)),
            border: InputBorder.none,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BlocBuilder<MessagesSearchBloc, MessagesSearchState>(
              builder: (context, state) {
            if (state is MessagesSearchStateInitial) {
              return const Center(child: Text('Search for a doctor'));
            }

            if (state is AllDoctorsStateLoading) {
              return Center(
                  child: CustomLoadingAnimation(
                size: 25,
                color: theme.primary,
              ));
            }

            if (state is AllDoctorsStateLoaded) {
              // Update all doctors and filtered doctors
              _allDoctors = state.doctors;
              _filteredDoctors = _searchController.text.isEmpty
                  ? _allDoctors
                  : _filteredDoctors;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text('Available Doctors',
                      style: TextStyle(
                          color: theme.primary, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: _filteredDoctors.isEmpty
                        ? const Center(
                            child: Text('No doctors found'),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.only(top: 10),
                            physics: BouncingScrollPhysics(),
                            itemCount: _filteredDoctors.length,
                            itemBuilder: (context, index) {
                              final doctor = _filteredDoctors[index];
                              return GestureDetector(
                                onTap: () async {
                                  final user =
                                      await HiveRepository().getUserInfo();

                                  Navigator.of(context).push(CupertinoPageRoute(
                                      builder: (context) => ConverationScreen(
                                            doctor: doctor,
                                            userId: user!['id'],
                                            doctorId: doctor.id,
                                          )));
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    color: theme.primary.withOpacity(.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 25,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              doctor.imageUrl),
                                    ),
                                    title: Text(doctor.name),
                                    subtitle: Text(doctor.specialization),
                                    trailing: Icon(Icons.arrow_forward_ios,
                                        color: theme.primary.withOpacity(.5),
                                        size: 18),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            }

            return const Center(child: Text('Error fetching doctors'));
          }),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
