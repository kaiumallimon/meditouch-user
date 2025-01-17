import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meditouch/common/widgets/custom_loading_animation.dart';
import 'package:meditouch/features/dashboard/features/appointments/data/repository/review_repository.dart';
import 'package:meditouch/features/dashboard/features/doctors/data/models/doctor_model.dart';
import 'package:meditouch/features/dashboard/features/doctors/data/repository/doctor_repository.dart';
import 'package:meditouch/features/dashboard/features/doctors/presentation/screens/doctor_detailed_page.dart';
import 'package:quickalert/quickalert.dart';

class DoctorSearchScreen extends StatefulWidget {
  const DoctorSearchScreen({super.key, this.searchQuery});

  final String? searchQuery;

  @override
  _DoctorSearchScreenState createState() => _DoctorSearchScreenState();
}

class _DoctorSearchScreenState extends State<DoctorSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<DoctorModel> _filteredDoctors = [];
  List<DoctorModel> _allDoctors = [];
  late StreamSubscription<List<DoctorModel>> _doctorStreamSubscription;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchQuery?.trim() ?? '';

    // Listen to the doctor stream
    _doctorStreamSubscription =
        DoctorRepository().getDoctors().listen((doctors) {
          setState(() {
            _allDoctors = doctors;
            _applySearchQuery(); // Filter the list after fetching
            _isLoading = false;
          });
        }, onError: (error) {
          setState(() {
            _isLoading = false; // Handle errors
          });
        });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _doctorStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: _filterDoctors, // Call filter function on input change
          decoration: InputDecoration(
            hintText: 'Search for doctors',
            hintStyle: TextStyle(color: theme.onSurface.withOpacity(.5)),
            border: InputBorder.none,
          ),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(
          child: CustomLoadingAnimation(size: 25, color: theme.primary),
        )
            : _filteredDoctors.isEmpty
            ? Center(child: Text('No doctors found'))
            : ListView.builder(
          itemCount: _filteredDoctors.length,
          padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemBuilder: (context, index) {
            final doctor = _filteredDoctors[index];
            return GestureDetector(
              onTap: () async {
                QuickAlert.show(
                  context: context,
                  title: 'Loading',
                  text: 'Please wait...',
                  type: QuickAlertType.loading,
                );

                final rating =
                await ReviewRepository().calculateRating(doctor.id);

                Navigator.of(context).pop();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorDetailedPage(
                      doctor: doctor,
                      rating: rating,
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: theme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                    CachedNetworkImageProvider(doctor.imageUrl),
                  ),
                  title: Text(
                    doctor.name,
                    style: TextStyle(
                        color: theme.primary,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    doctor.specialization,
                    style: TextStyle(
                        color: theme.onSurface.withOpacity(.5)),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: theme.onSurface.withOpacity(.5),
                    size: 15,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Function to filter doctors based on search input
  void _filterDoctors(String query) {
    setState(() {
      _applySearchQuery();
    });
  }

  // Apply search query to the doctor list
  void _applySearchQuery() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      _filteredDoctors = _allDoctors; // Show all doctors when query is empty
    } else {
      _filteredDoctors = _allDoctors.where((doctor) {
        return doctor.name.toLowerCase().contains(query) ||
            doctor.email.toLowerCase().contains(query) ||
            doctor.phone.toLowerCase().contains(query) ||
            doctor.district.toLowerCase().contains(query) ||
            doctor.specialization.toLowerCase().contains(query);
      }).toList();
    }
  }
}
