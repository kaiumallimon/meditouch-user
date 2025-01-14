import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/common/utils/system_colors.dart';
import 'package:meditouch/features/auth/login/logic/login_bloc.dart';
import 'package:meditouch/features/auth/login/logic/login_event.dart';
import 'package:meditouch/features/auth/login/logic/login_state.dart';
import 'package:meditouch/features/auth/login/presentation/widgets/continue_with_google.dart';
import 'package:meditouch/features/auth/login/presentation/widgets/custom_passwordfield.dart';
import 'package:meditouch/features/auth/login/presentation/widgets/custom_emailfield.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../../../common/widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retain the status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // Get theme
    final theme = Theme.of(context).colorScheme;

    // // find theme cubit
    // final themeCubit = BlocProvider.of<ThemeCubit>(context);

    // bool darktheme = themeCubit.isDarkTheme();

    // changeSystemColor(darktheme);

    // Get device height

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginLoadingState) {
          QuickAlert.show(
              context: context,
              type: QuickAlertType.loading,
              barrierColor: Colors.grey.shade500.withOpacity(0.1),
              text: "Please wait!",
              disableBackBtn: true);
        }

        if (state is LoginSuccessState) {
          Navigator.of(context).pop();
          final String message = state.message;
          QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: message,
              disableBackBtn: true);

          emailController.clear();
          passwordController.clear();

          Navigator.pushReplacementNamed(context, '/dashboard');
        }

        if (state is LoginErrorState) {
          final String message = state.message;
          Navigator.of(context).pop();
          QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              text: message,
              disableBackBtn: true);
        }
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: theme.surfaceContainer,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Logo:
                  _buildLogo(context, theme),

                  const SizedBox(height: 20),

                  // Welcome message:
                  _buildWelcomeTitle(context, theme),

                  const SizedBox(height: 10),

                  // Sub-message:
                  _buildSubtitle(context, theme),

                  const SizedBox(height: 30),

                  // Email field:
                  _buildEmailField(context, theme),

                  const SizedBox(height: 15),

                  // Password field:
                  _buildPasswordField(context, theme),

                  const SizedBox(height: 10),

                  // Forgot Password:
                  _buildForgotPasswordWidget(context, theme),

                  const SizedBox(height: 20),

                  // Sign in button:
                  _buildSignInButton(context, theme),

                  const SizedBox(height: 20),

                  // Create account:
                  _buildCreateAccountWidget(context, theme),

                  const SizedBox(height: 30),

                  // Or:
                  _buildOrText(theme),

                  const SizedBox(height: 30),

                  // Continue with Google:
                  _buildGoogleSignIn(context, theme),
                ],
              ),
            ),
          )),
    );
  }

/* Function to build the logo */
  Widget _buildLogo(BuildContext context, ColorScheme theme) {
    return Center(
      child: Image.asset(
        'assets/images/logo2.png',
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.height * 0.15,
        color: theme.primary.withOpacity(0.7),
      ),
    )
        .animate()
        .fade(
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 800),
        )
        .scaleXY(
          begin: 0.9,
          end: 1.0,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 800),
        );
  }

  /* Function to build the welcome title */
  Widget _buildWelcomeTitle(BuildContext context, ColorScheme theme) {
    return Center(
      child: Text(
        'Welcome!',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: theme.onSurface.withOpacity(0.8),
        ),
      ),
    )
        .animate()
        .fade(
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 800),
        )
        .scaleXY(
          begin: 0.9,
          end: 1.0,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 800),
        );
  }

  /* Function to build the subtitle */
  Widget _buildSubtitle(BuildContext context, ColorScheme theme) {
    return Center(
      child: Text(
        'To continue, sign in to your account',
        style: TextStyle(
          fontSize: 16,
          color: theme.onSurface.withOpacity(0.6),
        ),
        textAlign: TextAlign.center,
      ),
    )
        .animate()
        .fade(
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 800),
        )
        .scaleXY(
          begin: 0.9,
          end: 1.0,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 800),
        );
  }

  /* Function to build the email field */
  Widget _buildEmailField(BuildContext context, ColorScheme theme) {
    return CustomEmailfield(
      hint: "Email Address",
      size: Size(MediaQuery.of(context).size.width * 0.9, 50),
      bgColor: theme.primaryContainer.withOpacity(0.1),
      fgColor: theme.onSurface,
      keyboardType: TextInputType.emailAddress,
      iconColor: theme.primary.withOpacity(0.7),
      controller: emailController,
    )
        .animate()
        .fade(
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 800),
        )
        .scaleXY(
          begin: 0.9,
          end: 1.0,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 800),
        );
  }

  /* Function to build the password field */
  Widget _buildPasswordField(BuildContext context, ColorScheme theme) {
    return CustomPasswordfield(
      hint: "Password",
      size: Size(MediaQuery.of(context).size.width * 0.9, 50),
      bgColor: theme.primaryContainer.withOpacity(0.1),
      fgColor: theme.onSurface,
      keyboardType: TextInputType.text,
      iconColor: theme.primary.withOpacity(0.7),
      controller: passwordController,
    )
        .animate()
        .fade(
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 800),
        )
        .scaleXY(
          begin: 0.9,
          end: 1.0,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 800),
        );
  }

/* Function to build the forgot password widget */
  Widget _buildForgotPasswordWidget(BuildContext context, ColorScheme theme) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          // handle forgot password
        },
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.red,
          ),
        ),
      ),
    )
        .animate()
        .fade(
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 800),
        )
        .scaleXY(
          begin: 0.9,
          end: 1.0,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 800),
        );
  }

/* Function to build the sign in button */
  Widget _buildSignInButton(BuildContext context, ColorScheme theme) {
    return CustomButton(
      size: Size(MediaQuery.of(context).size.width * 0.9, 50),
      text: "Sign in",
      onPressed: () {
        final String email = emailController.text.trim();
        final String password = passwordController.text.trim();
        BlocProvider.of<LoginBloc>(context).add(
          LoginSubmitted(email: email, password: password),
        );
      },
      bgColor: theme.primary,
      fgColor: theme.onPrimary,
      isLoading: false,
    )
        .animate()
        .fade(
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 800),
        )
        .scaleXY(
          begin: 0.9,
          end: 1.0,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 800),
        );
  }

  /* Function to build the create account widget */
  Widget _buildCreateAccountWidget(BuildContext context, ColorScheme theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: TextStyle(
            fontSize: 14,
            color: theme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/register');
          },
          child: Text(
            "Create an account",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: theme.secondary,
            ),
          ),
        ),
      ],
    )
        .animate()
        .fade(
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 800),
        )
        .scaleXY(
          begin: 0.9,
          end: 1.0,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 800),
        );
  }

  /* Function to build the or text */
  Widget _buildOrText(ColorScheme theme) {
    return Center(
      child: Text(
        "Or",
        style: TextStyle(
          fontSize: 14,
          color: theme.onSurface.withOpacity(0.6),
        ),
      ),
    )
        .animate()
        .fade(
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 800),
        )
        .scaleXY(
          begin: 0.9,
          end: 1.0,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 800),
        );
  }

  /* Function to build the google sign in button */
  Widget _buildGoogleSignIn(BuildContext context, ColorScheme theme) {
    return CustomGoogleButton(
      size: Size(MediaQuery.of(context).size.width * 0.9, 50),
      text: "Continue with Google",
      onPressed: () {
        // Handle Google sign in
        QuickAlert.show(
            context: context,
            headerBackgroundColor: theme.primary,
            backgroundColor: theme.surface,
            textColor: theme.onSurface,
            titleColor: theme.onSurface,
            barrierColor: Colors.black.withOpacity(.7),
            type: QuickAlertType.warning,
            text: "Not Implemented Yet!",
            disableBackBtn: true);
      },
      bgColor: theme.primaryContainer,
      fgColor: Colors.black,
      isLoading: false,
    )
        .animate()
        .fade(
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 800),
        )
        .scaleXY(
          begin: 0.9,
          end: 1.0,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 800),
        );
  }

/* Controller for email and password fields */
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
}
