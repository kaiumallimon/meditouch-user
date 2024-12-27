import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditouch/common/widgets/custom_button.dart';
import 'package:meditouch/common/widgets/widget_motion.dart';
import 'package:meditouch/features/auth/login/presentation/widgets/custom_passwordfield.dart';
import 'package:meditouch/features/auth/register/logic/date_cubit.dart';
import 'package:meditouch/features/auth/register/logic/gender_cubit.dart';
import 'package:meditouch/features/auth/register/logic/image_cubit.dart';
import 'package:meditouch/features/auth/register/logic/register_bloc.dart';
import 'package:meditouch/features/auth/register/presentation/widgets/custom_datepicker.dart';
import 'package:meditouch/features/auth/register/presentation/widgets/custom_genderpicker.dart';
import 'package:meditouch/features/auth/register/presentation/widgets/custom_imagepicker.dart';
import 'package:meditouch/features/auth/register/presentation/widgets/custom_textfield_reg.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../logic/register_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    // Retain the status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    //get theme
    final theme = Theme.of(context).colorScheme;

    // set status bar color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: theme.surface,
      systemNavigationBarIconBrightness: theme.brightness,
    ));

    // get the bloc
    final registrationBloc = BlocProvider.of<RegisterBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a new account'),
        backgroundColor: theme.primary,
        foregroundColor: theme.onPrimary,
        toolbarHeight: 70,
        leading: IconButton(
          onPressed: isLoading
              ? null // Disable the back button when loading
              : () {
                  Navigator.of(context).pushReplacementNamed('/login');
                },
          icon: const Icon(CupertinoIcons.back),
          disabledColor: theme.onPrimary.withOpacity(.5),
        ),
      ),
      body: SafeArea(
        // bloc listener to listen any changes
        // in current states
        child: BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            // current state is loading state
            // show the loading animation
            if (state is RegisterLoadingState) {
              setState(() {
                isLoading = true;
              });
            }

            // registration successful
            // close the loading and
            // show an alert

            if (state is RegisterSuccessState) {
              setState(() {
                isLoading = false;
              });

              String message = state.message;

              _clearForm();
              Navigator.of(context).pushReplacementNamed('/login');

              QuickAlert.show(
                  context: context,
                  type: QuickAlertType.success,
                  text: message,
                  disableBackBtn: true);
            }

            // registration failed
            // close the loading animation and
            // show a alert

            if (state is RegisterErrorState) {
              setState(() {
                isLoading = false;
              });
              String message = state.message;
              QuickAlert.show(
                  context: context,
                  type: QuickAlertType.error,
                  text: message,
                  disableBackBtn: true);
            }
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              children: [
                const WidgetMotion(
                  direction: "left",
                  child: Text(
                      'Fill the information below to continue setting up your account.'),
                ),
                const SizedBox(height: 25),
                WidgetMotion(
                  direction: "right",
                  child: CustomTextfield(
                    iconData: Icons.abc,
                    hint: "Full name",
                    size: const Size(350, 50),
                    bgColor: theme.primary.withOpacity(.1),
                    fgColor: theme.onSurface,
                    controller: _nameController,
                  ),
                ),
                const SizedBox(height: 10),
                WidgetMotion(
                  direction: "left",
                  child: CustomTextfield(
                    iconData: Icons.numbers,
                    hint: "Phone number",
                    size: const Size(350, 50),
                    bgColor: theme.primary.withOpacity(.1),
                    fgColor: theme.onSurface,
                    controller: _phoneController,
                  ),
                ),
                const SizedBox(height: 10),
                WidgetMotion(
                  direction: "right",
                  child: CustomTextfield(
                    iconData: Icons.mail_outline,
                    hint: "Email address",
                    size: const Size(350, 50),
                    bgColor: theme.primary.withOpacity(.1),
                    fgColor: theme.onSurface,
                    controller: _emailController,
                  ),
                ),
                const SizedBox(height: 10),
                WidgetMotion(
                  direction: "left",
                  child: CustomDatePicker(
                    label: "Select Date",
                    width: 350,
                    height: 50,
                    bgColor: theme.primary.withOpacity(.1),
                    fgColor: theme.onSurface,
                    hasBorder: false,
                  ),
                ),
                const SizedBox(height: 10),
                WidgetMotion(
                  direction: "right",
                  child: GenderPicker(
                    width: 350,
                    height: 50,
                    bgColor: theme.primary.withOpacity(.1),
                    fgColor: theme.onSurface,
                    hasBorder: false,
                  ),
                ),
                const SizedBox(height: 10),
                WidgetMotion(
                  direction: "left",
                  child: CustomPasswordfield(
                    hint: "Password",
                    size: const Size(350, 50),
                    bgColor: theme.primary.withOpacity(.1),
                    fgColor: theme.onSurface,
                    controller: _passwordController,
                  ),
                ),
                const SizedBox(height: 10),
                WidgetMotion(
                  direction: "right",
                  child: CustomPasswordfield(
                    hint: "Confirm Password",
                    size: const Size(350, 50),
                    bgColor: theme.primary.withOpacity(.1),
                    fgColor: theme.onSurface,
                    controller: _confirmpasswordController,
                  ),
                ),
                const SizedBox(height: 10),
                WidgetMotion(
                  direction: "left",
                  child: CustomImagePicker(
                    width: 350,
                    height: 50,
                    bgColor: theme.primary.withOpacity(.1),
                    fgColor: theme.onSurface,
                    hasBorder: false,
                  ),
                ),
                const SizedBox(height: 20),
                WidgetMotion(
                  direction: "right",
                  child: CustomButton(
                    size: const Size(350, 50),
                    text: "Sign up",
                    onPressed: () {
                      try {
                        final String name = _nameController.text.trim();
                        final String phone = _phoneController.text.trim();
                        final String email = _emailController.text.trim();
                        final DateTime? dob =
                            BlocProvider.of<DateCubit>(context).state;
                        final String? gender =
                            BlocProvider.of<GenderCubit>(context).state;
                        final String password = _passwordController.text.trim();
                        final String confirmPassword =
                            _confirmpasswordController.text.trim();
                        final XFile? image =
                            BlocProvider.of<ImagePickerCubit>(context).state;

                        registrationBloc.add(RegisterSubmitted(
                            name: name,
                            phone: phone,
                            email: email,
                            gender: gender,
                            dob: dob,
                            password: password,
                            confirmPassword: confirmPassword,
                            image: image));
                      } catch (e) {
                        log(e.toString());
                      }
                    },
                    bgColor: theme.primary,
                    fgColor: theme.onPrimary,
                    isLoading: isLoading,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();

  bool isLoading = false;

  void _clearForm() {
    // Clear the text fields
    _nameController.clear();
    _phoneController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmpasswordController.clear();

    // Reset the Cubit states (set to null or initial state)
    BlocProvider.of<DateCubit>(context).reset();
    BlocProvider.of<GenderCubit>(context).reset();
    BlocProvider.of<ImagePickerCubit>(context).reset();
  }
}
