import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import './../../data/repository/nurse_repository.dart';
import '../../../epharmacy/presentation/screens/load_medicine_from_prescription_screen.dart';
import '../../data/model/nurse_model.dart';

class HireNursePage extends StatefulWidget {
  const HireNursePage({super.key});

  @override
  _HireNursePageState createState() => _HireNursePageState();
}

class _HireNursePageState extends State<HireNursePage> {
  final TextEditingController _searchController = TextEditingController();
  List<NurseModel> _filteredNurses = [];
  List<NurseModel> _allNurses = [];

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
              title: 'Nurses',
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
                    _filteredNurses = _filterNurses(value);
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<List<NurseModel>>(
                stream: NurseRepository().getNurses(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('An error occurred'));
                  }

                  if (snapshot.hasData) {
                    _allNurses = snapshot.data!;
                    _filteredNurses = _filterNurses(_searchController.text);

                    if (_filteredNurses.isEmpty) {
                      return Center(child: Text('No search results found.'));
                    }

                    return ListView.builder(
                      itemCount: _filteredNurses.length,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final nurse = _filteredNurses[index];
                        return _buildNurseCard(nurse, theme);
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
  List<NurseModel> _filterNurses(String query) {
    if (query.isEmpty) {
      return _allNurses;
    }

    return _allNurses.where((nurse) {
      final searchLower = query.toLowerCase();
      return nurse.name.toLowerCase().contains(searchLower) ||
          nurse.email.toLowerCase().contains(searchLower) ||
          nurse.district.toLowerCase().contains(searchLower) ||
          nurse.phone.toLowerCase().contains(searchLower);
    }).toList();
  }

  // Widget to build a single nurse card
  Widget _buildNurseCard(NurseModel nurse, ColorScheme theme) {
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