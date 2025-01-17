import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditouch/common/repository/hive_repository.dart';
import 'package:meditouch/common/widgets/custom_button.dart';
import 'package:meditouch/common/widgets/custom_loading_animation.dart';
import 'package:meditouch/features/dashboard/features/family-members/data/models/family_member_model.dart';
import 'package:meditouch/features/dashboard/features/family-members/data/repository/family_member_repository.dart';
import 'package:quickalert/quickalert.dart';

class FamilyMemberScreen extends StatelessWidget {
  const FamilyMemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // get theme:
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        backgroundColor: theme.surfaceContainer,
        elevation: 0,
        surfaceTintColor: theme.surfaceContainer,
        title: const Text('Family Members'),
      ),
      body: SafeArea(child: buildFamilyMembersBody(context, theme)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const FamilyMembersAddScreen(),
            ),
          );
        },
        backgroundColor: theme.primary,
        foregroundColor: theme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildFamilyMembersBody(BuildContext context, ColorScheme theme) {
    return FutureBuilder(
        future: HiveRepository().getUserInfo(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CustomLoadingAnimation(size: 25, color: theme.primary),
            );
          }

          if (userSnapshot.hasError || userSnapshot.data == null) {
            return Center(
              child: Text('An error occurred'),
            );
          }

          final userId = userSnapshot.data!['id'];

          return StreamBuilder(
              stream: FamilyMemberRepository().getFamilyMemberStream(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child:
                        CustomLoadingAnimation(size: 25, color: theme.primary),
                  );
                }

                if (snapshot.hasError || snapshot.data == null) {
                  return Center(
                    child: Text('An error occurred'),
                  );
                }


                final FamilyMemberModel familyMemberModel = snapshot.data!;
                final List<PersonModel> members =
                    familyMemberModel.familyMembers;

                if (members.isEmpty) {
                  return Center(
                    child: Text('No family members found'),
                  );
                }
                return ListView.builder(
                  itemCount: members.length,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(members[index].email),
                      onDismissed: (direction) {
                        if (direction == DismissDirection.endToStart) {
                          // remove member
                          FamilyMemberRepository()
                              .removeMember(userId, members[index].email);
                        }
                      },
                      child: GestureDetector(
                        child: SizedBox(
                          child: Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.all(15),
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: theme.primaryContainer,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 5,
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              members[index].image ?? ""),
                                    ),
                                    ListTile(
                                      title: Text(
                                        'Name',
                                        style: TextStyle(
                                            fontSize: 13, color: theme.primary),
                                      ),
                                      subtitle: Text(
                                        members[index].name,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: theme.onSurface),
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(
                                        'Email',
                                        style: TextStyle(
                                            fontSize: 13, color: theme.primary),
                                      ),
                                      subtitle: Text(
                                        members[index].email,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: theme.onSurface),
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(
                                        'Phone Number',
                                        style: TextStyle(
                                            fontSize: 13, color: theme.primary),
                                      ),
                                      subtitle: Text(
                                        members[index].phoneNumber,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: theme.onSurface),
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(
                                        'Date of Birth',
                                        style: TextStyle(
                                            fontSize: 13, color: theme.primary),
                                      ),
                                      subtitle: Text(
                                        formatDOB(members[index].dob),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: theme.onSurface),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: theme.secondary,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10))),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
                                  child: Text(
                                    members[index].relationShip,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              });
        });
  }
}

String formatDOB(String dobIso) {
  final dob = DateTime.parse(dobIso);
  return '${dob.year}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}';
}

///
///
///
///
///
///
/// Add Family Member
///
///
///
///
///
class FamilyMembersAddScreen extends StatefulWidget {
  const FamilyMembersAddScreen({super.key});

  @override
  State<FamilyMembersAddScreen> createState() => _FamilyMembersAddScreenState();
}

class _FamilyMembersAddScreenState extends State<FamilyMembersAddScreen> {
  // controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _relationShipController = TextEditingController();

  // image
  XFile? _image;
  String? _imageUrl;

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = pickedImage;
      });

      // upload image to firebase storage
      String? response = await FamilyMemberRepository().uploadImage(_image!);

      setState(() {
        _imageUrl = response;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // get theme
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        backgroundColor: theme.surfaceContainer,
        elevation: 0,
        surfaceTintColor: theme.surfaceContainer,
        title: const Text('Add Family Member'),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'To add a family member, please fill the form below then click on the save button'),
            const SizedBox(height: 20),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 15,
                children: [
                  // name
                  buildCustomTextField(context, theme, _nameController, 'Name'),
                  // email
                  buildCustomTextField(
                      context, theme, _emailController, 'Email'),
                  // phone number
                  buildCustomTextField(
                      context, theme, _phoneNumberController, 'Phone Number'),
                  // date of birth [dob] - date picker
                  buildDatePicker(context, theme),

                  // gender [dropdown]
                  buildGenderDropDown(context, theme),

                  // relationship [text field]
                  buildCustomTextField(
                      context, theme, _relationShipController, 'Relationship'),

                  // image [image picker]
                  buildImagePicker(context, theme),

                  // save button
                  buildSaveButton(context, theme)
                ],
              ),
            ))
          ],
        ),
      )),
    );
  }

  final List<String> _gendersList = ["Male", "Female"];

  String? _selectedGender;

  Widget buildGenderDropDown(BuildContext context, ColorScheme theme) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedGender,
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: theme.onSurface),
          onChanged: (String? newValue) {
            setState(() {
              _selectedGender = newValue;
            });
          },
          hint: Text(
            _selectedGender ?? "Select gender",
            style: TextStyle(
              color: theme.onSurface.withOpacity(0.5),
            ),
          ),
          iconEnabledColor: theme.onSurface.withOpacity(.5),
          items: _gendersList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  DateTime? _selectedDate;

  void openDatePicker() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
      });
    }
  }

  Widget buildSaveButton(BuildContext context, ColorScheme theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomButton(
          size: Size(120, 45),
          text: "Save",
          onPressed: () async {
            // Check if any required fields are empty or invalid
            if (_nameController.text.trim().isEmpty ||
                _emailController.text.trim().isEmpty ||
                _phoneNumberController.text.trim().isEmpty ||
                _relationShipController.text.trim().isEmpty ||
                _selectedGender == null ||
                _selectedDate == null) {
              // Show error message
              QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                text: "Please fill all fields",
              );
              return;
            }

            // Show loading indicator
            QuickAlert.show(
              context: context,
              type: QuickAlertType.loading,
              barrierDismissible: false,
            );

            // Extract the values from the controllers
            final String name = _nameController.text.trim();
            final String email = _emailController.text.trim();
            final String phoneNumber = _phoneNumberController.text.trim();
            final String relationShip = _relationShipController.text.trim();

            // Get userId from local storage (Hive)
            final user = await HiveRepository().getUserInfo();
            final userId = user!['id'];

            // Create a member object
            final member = PersonModel(
              name: name,
              email: email,
              image: _imageUrl ??
                  (_selectedGender == "Male"
                      ? "https://media.istockphoto.com/id/1327592506/vector/default-avatar-photo-placeholder-icon-grey-profile-picture-business-man.jpg?s=612x612&w=0&k=20&c=BpR0FVaEa5F24GIw7K8nMWiiGmbb8qmhfkpXcp1dhQg="
                      : "https://media.istockphoto.com/id/2014684899/vector/placeholder-avatar-female-person-default-woman-avatar-image-gray-profile-anonymous-face.jpg?s=612x612&w=0&k=20&c=D-dk9ek0_jb19TiMVNVmlpvYVrQiFiJmgGmiLB5yE4w="),
              phoneNumber: phoneNumber,
              dob: _selectedDate!.toIso8601String(),
              gender: _selectedGender!,
              relationShip: relationShip,
            );

            // Add the family member to the repository
            final response =
                await FamilyMemberRepository().addFamilyMember(userId, member);

            // Handle success or failure
            if (response) {
              Navigator.of(context).pop();
              // Clear form fields
              _nameController.clear();
              _emailController.clear();
              _phoneNumberController.clear();
              _relationShipController.clear();
              _selectedGender = null;
              _selectedDate = null;
              _image = null;

              // Show success message
              QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                onConfirmBtnTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                text: 'Member added successfully',
              );
            } else {
              // Show error message
              QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                text: 'Failed to add member',
              );
            }
          },
          bgColor: theme.primary,
          fgColor: theme.onPrimary,
          isLoading: false,
        )
      ],
    );
  }

  Widget buildImagePicker(BuildContext context, ColorScheme theme) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _image == null ? 'Select Image (Optional)' : _image!.name,
              style: TextStyle(
                  color: theme.onSurface.withOpacity(0.5), fontSize: 14),
            ),
            Icon(Icons.image, color: theme.onSurface.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }

  Widget buildDatePicker(BuildContext context, ColorScheme theme) {
    final formattedDate = _selectedDate != null
        ? '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}'
        : 'Date of Birth';

    return GestureDetector(
      onTap: openDatePicker,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formattedDate,
              style: TextStyle(
                color: theme.onSurface.withOpacity(0.5),
                fontSize: 14,
              ),
            ),
            Icon(Icons.calendar_today, color: theme.onSurface.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }

  Widget buildCustomTextField(BuildContext context, ColorScheme theme,
      TextEditingController controller, String hint) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller,
        style: TextStyle(color: theme.onSurface, fontSize: 14),
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: theme.onSurface.withOpacity(0.5)),
        ),
      ),
    );
  }
}
