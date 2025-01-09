import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../../common/utils/epharmacy_util.dart';
import '../../logics/medicine_scan_state.dart';
import 'detailed_medicine.dart';

ListView scannedMedicineList(ScanResult state, ColorScheme theme) {
    return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            physics: const BouncingScrollPhysics(),
            itemCount: state.medicines.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetailedMedicineScreen(
                            medicineName: state.medicines[index].medicineName,
                            slug: state.medicines[index].slug)));
                  },
                  tileColor: theme.primaryContainer,
                  leading: CachedNetworkImage(
                    imageUrl:
                        getImageUrl(state.medicines[index].medicineImage),
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      "${state.medicines[index].medicineName} ${state.medicines[index].strength}"),
                  subtitle: Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      state.medicines[index].manufacturerName,
                      style: TextStyle(
                          color: theme.primary.withOpacity(.7),
                          fontSize: 13)),
                ),
              );
            },
          );
  }