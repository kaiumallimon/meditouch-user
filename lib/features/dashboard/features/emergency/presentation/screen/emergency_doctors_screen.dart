import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../epharmacy/presentation/screens/load_medicine_from_prescription_screen.dart';
import '../../data/model/emergency_model.dart';
import '../../data/repository/emergency_repository.dart';


class EmergencyDoctorPage extends StatefulWidget {
  const EmergencyDoctorPage({super.key});

  @override
  _HireNursePageState createState() => _HireNursePageState();
}

class _HireNursePageState extends State<EmergencyDoctorPage> {
  final TextEditingController _searchController = TextEditingController();
  List<EmergencyDoctorModel> _filteredDoctors = [];
  List<EmergencyDoctorModel> _allDoctors = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              vPadding: 14,
              hasBackButton: true,
              backButtonBorderColor: theme.primary.withOpacity(.3),
              title: 'Doctors',
              textColor: theme.primary,
              textSize: 18,
              bgColor: theme.surface,
            ),
            const SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: CupertinoSearchTextField(
                controller: _searchController,
                backgroundColor: theme.primary.withOpacity(.1),
                prefixIcon: Icon(Icons.search, color: theme.primary),
                placeholder: 'Search by name, email, district, or phone',
                style: TextStyle(color: theme.primary),
                onChanged: (value) {
                  setState(() {
                    _filteredDoctors = _filterDoctors(value);
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<List<EmergencyDoctorModel>>(
                stream: FirebaseEmergencyService().getEmergencyDoctors(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('An error occurred'));
                  }

                  if (snapshot.hasData) {
                    _allDoctors = snapshot.data!;
                    _filteredDoctors = _filterDoctors(_searchController.text);

                    if (_filteredDoctors.isEmpty) {
                      return Center(child: Text('No search results found.'));
                    }

                    return ListView.builder(
                      itemCount: _filteredDoctors.length,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final doctor = _filteredDoctors[index];
                        return _buildDoctorCard(doctor, theme);
                      },
                    );
                  }

                  return Center(child: Text('No nurses available.'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Filter nurses based on search query
  List<EmergencyDoctorModel> _filterDoctors(String query) {
    if (query.isEmpty) {
      return _allDoctors;
    }

    return _allDoctors.where((nurse) {
      final searchLower = query.toLowerCase();
      return nurse.name.toLowerCase().contains(searchLower) ||
          nurse.email.toLowerCase().contains(searchLower) ||
          nurse.district.toLowerCase().contains(searchLower) ||
          nurse.phone.toLowerCase().contains(searchLower);
    }).toList();
  }

  // Widget to build a single nurse card
  Widget _buildDoctorCard(EmergencyDoctorModel nurse, ColorScheme theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.primary.withOpacity(.1),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: CachedNetworkImageProvider(nurse.image),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${nurse.name} (${nurse.gender})",
                  maxLines: 2,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(nurse.district, style: TextStyle(fontSize: 14)),
                Text(nurse.email, style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
          IconButton.filled(
            onPressed: () async {
              if (!await launchUrl(Uri.parse('tel:${nurse.phone}'))) {
                throw Exception('Could not call ${nurse.phone}');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primary,
              foregroundColor: theme.onPrimary,
            ),
            icon: Icon(Icons.call),
          )
        ],
      ),
    );
  }
}