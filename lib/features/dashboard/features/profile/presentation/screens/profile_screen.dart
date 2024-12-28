import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import 'package:meditouch/common/utils/datetime_format.dart';
import 'package:meditouch/common/widgets/custom_list_tile.dart';
import 'package:meditouch/features/dashboard/features/profile/logics/profile_bloc.dart';
import 'package:meditouch/features/dashboard/features/profile/logics/profile_event.dart';
import 'package:meditouch/features/dashboard/features/profile/logics/profile_state.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    // Access the arguments passed to the route
    final Map<String, dynamic> userInfo =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return SafeArea(
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              title: state.message,
              text: "Please restart the app to see changes",
            );
          }
          if (state is ProfileUpdateError) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'Error',
              text: state.message,
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return Scaffold(
                backgroundColor: theme.surfaceContainer,
                body: _buildLoadingIndicator(theme));
          }
          if (state is ProfileError) {
            return _buildErrorMessage(state.message);
          }

          return Scaffold(
            backgroundColor: theme.surfaceContainer,
            appBar: _buildAppBar(context, state, theme, userInfo['id']),
            body: _buildProfileContent(context, state, theme, user: userInfo),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(
      BuildContext context, ProfileState state, ColorScheme theme, String uid) {
    return AppBar(
      toolbarHeight: 70,
      elevation: 0,
      surfaceTintColor: theme.surfaceContainer,
      backgroundColor: theme.surfaceContainer,
      title: Text(
        'Profile',
        style: TextStyle(
          color: theme.primary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        if (state is! ProfileEditState)
          TextButton(
            onPressed: () {
              context.read<ProfileBloc>().add(const ProfileEdit());
            },
            child: Text('Edit Profile', style: TextStyle(color: theme.primary)),
          ),
        if (state is ProfileEditState)
          TextButton(
            onPressed: () {
              context.read<ProfileBloc>().add(
                    const ProfileEditDone(),
                  );

              context.read<ProfileBloc>().add(
                    UpdateProfile(
                      uid: uid,
                      data: {
                        'name': _nameController.text,
                        'phone': _phoneController.text,
                      },
                    ),
                  );
            },
            child: Text('Done', style: TextStyle(color: theme.primary)),
          ),
      ],
    );
  }

  Widget _buildLoadingIndicator(ColorScheme theme) {
    return Center(
      child: CupertinoActivityIndicator(
        color: theme.primary,
        radius: 12,
      ),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Center(
      child: Text(message),
    );
  }

  Widget _buildProfileContent(
      BuildContext context, ProfileState state, ColorScheme theme,
      {required Map<String, dynamic> user}) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          _buildProfilePicture(user['image'], theme,
              isEditable: state is ProfileEditState),
          const SizedBox(height: 40),
          _buildEditableField(
            icon: Icons.person,
            label: 'Name',
            value: user['name'],
            isEditable: state is ProfileEditState,
            controller: _nameController,
            theme: theme,
          ),
          const SizedBox(height: 10),
          _buildEditableField(
            icon: Icons.phone,
            label: 'Phone',
            value: user['phone'],
            isEditable: state is ProfileEditState,
            controller: _phoneController,
            theme: theme,
          ),
          const SizedBox(height: 10),
          _buildReadOnlyField(
            icon: Icons.calendar_month,
            label: 'Date of Birth',
            value: user['dob'],
            theme: theme,
          ),
          const SizedBox(height: 10),
          _buildReadOnlyField(
            icon: Icons.email,
            label: 'Email',
            value: user['email'],
            theme: theme,
          ),
          const SizedBox(height: 10),
          _buildReadOnlyField(
            icon: Icons.wc,
            label: 'Gender',
            value: user['gender'],
            theme: theme,
          ),
          const SizedBox(height: 10),
          _buildReadOnlyField(
            icon: Icons.numbers,
            label: 'UID',
            value: user['id'],
            theme: theme,
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePicture(String imageUrl, ColorScheme theme,
      {required bool isEditable}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 150,
        width: 150,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: theme.primary.withOpacity(.5),
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(150),
          child: Stack(
            children: [
              if (isEditable)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.primary,
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              CachedNetworkImage(
                imageUrl: imageUrl,
                placeholder: (context, url) => const Center(
                  child: CupertinoActivityIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required String value,
    required bool isEditable,
    required TextEditingController controller,
    required ColorScheme theme,
    required IconData icon,
  }) {
    return CustomListTile(
      backgroundColor: theme.primary.withOpacity(.1),
      tile: ListTile(
        leading: Icon(
          icon,
          color: theme.primary,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: theme.primary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: isEditable
            ? TextField(
                controller: controller..text = value,
                decoration: InputDecoration(
                  hintText: 'Enter your $label',
                  filled: true,
                  fillColor: theme.primary.withOpacity(.1),
                ),
              )
            : Text(
                value,
                style: TextStyle(
                  color: theme.onSurface,
                  fontSize: 16,
                ),
              ),
      ),
      borderRadius: 10,
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
    required IconData icon,
    required ColorScheme theme,
  }) {
    return CustomListTile(
      backgroundColor: theme.primary.withOpacity(.1),
      tile: ListTile(
        leading: Icon(
          icon,
          color: theme.primary,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: theme.primary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            color: theme.onSurface,
            fontSize: 16,
          ),
        ),
      ),
      borderRadius: 10,
    );
  }

  // Widget _buildDatePickerField({
  //   required String label,
  //   required String value,
  //   required bool isEditable,
  //   required TextEditingController controller,
  //   required BuildContext context,
  //   required ColorScheme theme,
  //   required IconData icon,
  // }) {
  //   return CustomListTile(
  //     backgroundColor: theme.primary.withOpacity(.1),
  //     tile: ListTile(
  //       leading: Icon(
  //         icon,
  //         color: theme.primary,
  //       ),
  //       title: Text(
  //         label,
  //         style: TextStyle(
  //           color: theme.primary,
  //           fontSize: 13,
  //           fontWeight: FontWeight.w600,
  //         ),
  //       ),
  //       subtitle: isEditable
  //           ? GestureDetector(
  //               onTap: () async {
  //                 final selectedDate = await showDatePicker(
  //                   context: context,
  //                   initialDate: DateTime.tryParse(value) ?? DateTime.now(),
  //                   firstDate: DateTime(1900),
  //                   lastDate: DateTime.now(),
  //                 );
  //                 if (selectedDate != null) {
  //                   controller.text = DateTimeFormatUtil().dobFormatter(
  //                     selectedDate.toIso8601String(),
  //                   );
  //                 }
  //               },
  //               child: AbsorbPointer(
  //                 child: TextField(
  //                   controller: controller,
  //                   decoration: InputDecoration(
  //                     hintText: 'Select your $label',
  //                     filled: true,
  //                     fillColor: theme.primary.withOpacity(.1),
  //                   ),
  //                 ),
  //               ),
  //             )
  //           : Text(
  //               DateTimeFormatUtil().dobFormatter(value),
  //               style: TextStyle(
  //                 color: theme.onSurface,
  //                 fontSize: 16,
  //               ),
  //             ),
  //     ),
  //     borderRadius: 10,
  //   );
  // }
}
