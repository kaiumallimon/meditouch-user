import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meditouch/common/widgets/custom_button.dart';
import 'package:meditouch/features/auth/login/presentation/widgets/custom_emailfield.dart';
import 'package:meditouch/features/auth/login/presentation/widgets/custom_passwordfield.dart';
import 'package:meditouch/features/auth/register/presentation/widgets/custom_datepicker.dart';
import 'package:meditouch/features/auth/register/presentation/widgets/custom_genderpicker.dart';
import 'package:meditouch/features/auth/register/presentation/widgets/custom_imagepicker.dart';
import 'package:meditouch/features/auth/register/presentation/widgets/custom_textfield_reg.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retain the status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    //get theme
    final theme = Theme.of(context).colorScheme;

    // get device size
    final size = MediaQuery.of(context).size;

    // set status bar color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      // statusBarColor: theme.surface,
      // statusBarIconBrightness: theme.brightness,
      systemNavigationBarColor: theme.surface,
      systemNavigationBarIconBrightness: theme.brightness,
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a new account'),
        backgroundColor: theme.primary,
        foregroundColor: theme.onPrimary,
        toolbarHeight: 70,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(CupertinoIcons.back)),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          children: [
            const Text(
                'Fill the information below to continue setting up your account.'),
            const SizedBox(
              height: 25,
            ),
            CustomTextfield(
                iconData: Icons.abc,
                hint: "Full name",
                size: Size(350, 50),
                bgColor: theme.primary.withOpacity(.1),
                fgColor: theme.onSurface,
                controller: _nameController),
            const SizedBox(
              height: 10,
            ),
            CustomTextfield(
                iconData: Icons.numbers,
                hint: "Phone number",
                size: Size(350, 50),
                bgColor: theme.primary.withOpacity(.1),
                fgColor: theme.onSurface,
                controller: _phoneController),
            const SizedBox(
              height: 10,
            ),
            CustomTextfield(
                iconData: Icons.mail_outline,
                hint: "Email address",
                size: Size(350, 50),
                bgColor: theme.primary.withOpacity(.1),
                fgColor: theme.onSurface,
                controller: _emailController),
            const SizedBox(
              height: 10,
            ),
            CustomDatePicker(
                label: "Select Date",
                width: 350,
                height: 50,
                bgColor: theme.primary.withOpacity(.1),
                fgColor: theme.onSurface,
                hasBorder: false),
            const SizedBox(
              height: 10,
            ),
            GenderPicker(
                width: 350,
                height: 50,
                bgColor: theme.primary.withOpacity(.1),
                fgColor: theme.onSurface,
                hasBorder: false),
            const SizedBox(
              height: 10,
            ),
            CustomPasswordfield(
                hint: "Password",
                size: Size(350, 50),
                bgColor: theme.primary.withOpacity(.1),
                fgColor: theme.onSurface,
                controller: _passwordController),
            const SizedBox(
              height: 10,
            ),
            CustomPasswordfield(
                hint: "Confirm Password",
                size: Size(350, 50),
                bgColor: theme.primary.withOpacity(.1),
                fgColor: theme.onSurface,
                controller: _confirmpasswordController),
            const SizedBox(
              height: 10,
            ),
            CustomImagePicker(
                width: 350,
                height: 50,
                bgColor: theme.primary.withOpacity(.1),
                fgColor: theme.onSurface,
                hasBorder: false),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
                size: Size(350, 50),
                text: "Sign up",
                onPressed: () {},
                bgColor: theme.primary,
                fgColor: theme.onPrimary,
                isLoading: false)
          ],
        ),
      )),
    );
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();
}
