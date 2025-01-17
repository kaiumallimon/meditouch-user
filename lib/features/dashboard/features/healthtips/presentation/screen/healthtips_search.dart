import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meditouch/features/dashboard/features/doctors/data/models/doctor_model.dart';
import 'package:meditouch/features/dashboard/features/healthtips/data/repository/healthtips_repository.dart';

import '../../../epharmacy/presentation/screens/load_medicine_from_prescription_screen.dart';
import 'detailed_healthtips.dart';


class HealthTipsSearchPage extends StatefulWidget {
  const HealthTipsSearchPage({super.key});

  @override
  _HealthTipsSearchPageState createState() => _HealthTipsSearchPageState();
}

class _HealthTipsSearchPageState extends State<HealthTipsSearchPage> {
  String _searchQuery = '';
  List<dynamic> _filteredHealthTips =
  []; // Replace dynamic with your health tip model

  @override
  void initState() {
    super.initState();
    // You may want to initialize the filtered health tips
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
          child: Column(
            children: [
              CustomAppBar(
                title: 'Search Health Tips',
                textColor: theme.primary,
                textSize: 18,
                bgColor: theme.surface,
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomTextField(
                    height: 50,
                    width: double.infinity,
                    bgColor: theme.primary.withOpacity(.1),
                    fgColor: theme.onSurface,
                    hint: 'Type to search',
                    onChanged: _updateSearchQuery),
              ),
              const SizedBox(height: 20),
              Expanded(
                  child: StreamBuilder<List<dynamic>>(
                    // Adjust the type accordingly
                      stream: HealthTipsRepository().getHealthTips(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        final blogDocs = snapshot.data!;
                        _filteredHealthTips = blogDocs.where((tip) {
                          return tip.title.toLowerCase().contains(_searchQuery) ||
                              tip.body.toLowerCase().contains(_searchQuery);
                        }).toList();

                        if (_searchQuery.isEmpty) {
                          return Center(
                            child: Text(
                              'Type something to search...',
                              style:
                              TextStyle(color: theme.onSurface.withOpacity(.5), fontSize: 15),
                            ),
                          );
                        }

                        if (_filteredHealthTips.isEmpty) {
                          return Center(
                            child: Text(
                              'No results found.',
                              style:
                              TextStyle(color: theme.onSurface, fontSize: 18),
                            ),
                          );
                        }

                        return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: _filteredHealthTips.length,
                            itemBuilder: (context, index) {
                              return StreamBuilder<DoctorModel>(
                                  stream: HealthTipsRepository().getDoctorById(
                                      _filteredHealthTips[index].doctorId),
                                  builder: (context, dcotorSnapshot) {
                                    return GestureDetector(
                                      onTap: () {
                                        // Navigate to the details view page
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetailedHealthServicePage(
                                                    healthTips:
                                                    _filteredHealthTips[index],
                                                    doctor: dcotorSnapshot.data!),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(bottom: 20),
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                            color: theme.surface,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                  color:
                                                  theme.primary.withOpacity(.1),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 5))
                                            ]),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                              child: CachedNetworkImage(
                                                imageUrl: _filteredHealthTips[index].image,
                                                height: 100,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                    Center(
                                                        child:
                                                        CircularProgressIndicator(
                                                            value: downloadProgress
                                                                .progress)),
                                              ),
                                            ),
                                            const SizedBox(height: 15),
                                            Text(
                                              _filteredHealthTips[index].title,
                                              style: TextStyle(
                                                  color: theme.primary,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            });
                      })),
            ],
          )),
    );
  }
}