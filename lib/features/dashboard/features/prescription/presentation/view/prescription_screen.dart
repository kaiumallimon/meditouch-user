import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditouch/features/dashboard/features/prescription/data/repository/prescription_repository.dart';
import 'package:meditouch/features/dashboard/features/prescription/presentation/view/remote_prescriptions.dart';
import 'package:quickalert/quickalert.dart';

import '../../../../../../common/repository/hive_repository.dart';
import '../../../../../../common/widgets/custom_loading_animation.dart';
import 'local_prescription_screen.dart';

class PrescriptionScreen extends StatelessWidget {
  const PrescriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // get theme
    final theme = Theme.of(context).colorScheme;
    return FutureBuilder(
        future: HiveRepository().getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CustomLoadingAnimation(size: 25, color: theme.primary),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final user = snapshot.data!;
          return Scaffold(
            backgroundColor: theme.surfaceContainer,
            appBar: AppBar(
              title: Text('Find your prescription',
                  style: TextStyle(color: theme.onSurface, fontSize: 16)),
              backgroundColor: theme.surfaceContainer,
            ),
            body: SafeArea(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 15,
              children: [
                const SizedBox(height: 0),
                buildPrescriptionMenu(context, theme, "From Appointments", () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return RemotePrescriptions(
                      userId: user['id'],
                    );
                  }));
                }),
                buildPrescriptionMenu(context, theme, "Local", () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return LocalPrescriptionScreen();
                  }));
                }),
              ],
            )),
            floatingActionButton: FloatingActionButton.extended(
              isExtended: true,
              onPressed: () {
                // show  a bottom modal sheet to select an image from gallery
                showAddPrescriptionMenu(context, theme, user['id']);
              },
              backgroundColor: theme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 5,
              label: Text('Add Local Prescription',
                  style: TextStyle(color: theme.onPrimary)),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
        });
  }

  Widget buildPrescriptionMenu(
      BuildContext context, ColorScheme theme, String label, Function? ontap) {
    return GestureDetector(
      onTap: ontap as void Function()?,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: theme.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(color: theme.onSurface)),
            Icon(Icons.arrow_forward_ios,
                size: 15, color: theme.onSurface.withOpacity(.5)),
          ],
        ),
      ),
    );
  }
}

void showAddPrescriptionMenu(
    BuildContext context, ColorScheme theme, String userId) {
  showModalBottomSheet(
      useSafeArea: true,
      context: context,
      builder: (context) {
        return AddPrescriptionScreen(
          userId: userId,
        );
      });
}

class AddPrescriptionScreen extends StatefulWidget {
  const AddPrescriptionScreen({super.key, required this.userId});
  final String userId;

  @override
  State<AddPrescriptionScreen> createState() => _AddPrescriptionScreenState();
}

class _AddPrescriptionScreenState extends State<AddPrescriptionScreen> {
  XFile? _image;

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // get theme
    final theme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 50),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: theme.surfaceContainer,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          SizedBox(
            height: 50,
            child: Stack(
              children: [
                Center(
                  child: Text(
                    'Add Prescription',
                    style: TextStyle(
                        color: theme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Positioned(
                  left: 0,
                  child: IconButton(
                    icon: Icon(Icons.save, color: theme.onSurface),
                    onPressed: () async {
                      // Check if an image is selected
                      if (_image == null) {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          text: 'Please select an image',
                        );
                        return;
                      }

                      // Show a loading alert
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.loading,
                        barrierDismissible: false,
                      );

                      try {
                        // Store the prescription
                        final response = await PrescriptionRepository()
                            .storeLocalPrescription(
                          image: _image!,
                          description: _descriptionController.text,
                          userId: widget.userId,
                        );

                        // Close the loading alert
                        Navigator.of(context).pop();

                        // Show a success or error alert based on the response
                        if (response) {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.success,
                            text: 'Prescription added successfully',
                            onConfirmBtnTap: () {
                              Navigator.of(context).pop();
                              _image = null;
                              _descriptionController.clear();
                              Navigator.of(context).pop();
                            },
                          );
                        } else {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            text: 'Failed to add prescription',
                          );
                        }
                      } catch (e) {
                        // Close the loading alert in case of error
                        Navigator.of(context).pop();

                        // Show an error alert
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          text: 'An error occurred: $e',
                        );
                      }
                    },
                  ),
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.close, color: theme.error),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              _getImage();
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: theme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  _image == null ? 'Select Image from Gallery' : _image!.name,
                  style: TextStyle(color: theme.onSurface),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: theme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                expands: true,
                maxLines: null,
                controller: _descriptionController,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter Prescription details (optional)',
                  hintStyle: TextStyle(color: theme.onSurface.withOpacity(.5)),
                  border: InputBorder.none,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  final TextEditingController _descriptionController = TextEditingController();
}
