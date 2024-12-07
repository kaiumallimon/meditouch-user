import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meditouch/common/widgets/gradient_bg.dart';
import 'package:meditouch/common/widgets/widget_motion.dart';
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

    // // Set status bar and nav bar colors:
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent,
    //   statusBarIconBrightness: Brightness.light,
    //   systemNavigationBarColor: theme.surface,
    //   systemNavigationBarIconBrightness: theme.brightness,
    // ));

    // Get device height
    final height = MediaQuery.of(context).size.height;


    return BlocListener<LoginBloc,LoginState>(
      listener: (context,state){
        if(state is LoginLoadingState){
          QuickAlert.show(
              context: context,
              type: QuickAlertType.loading,
              text: "Please wait!", disableBackBtn: true
          );
        }

        if(state is LoginSuccessState){
          Navigator.of(context).pop();
          final String message = state.message;
          QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: message, disableBackBtn: true
          );

          emailController.clear();
          passwordController.clear();

          Navigator.pushReplacementNamed(context, '/dashboard');
        }

        if(state is LoginErrorState){
          final String message = state.message;
          Navigator.of(context).pop();
          QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              text: message, disableBackBtn: true
          );
        }
      },
      child: Scaffold(
          body: Stack(
        fit: StackFit.expand,
        children: [
          const GradientBackground(),
          Positioned(
            top: (height * .10),
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/logo2.png',
              height: 130,
              width: 130,
            ),
          ),
          Positioned(
              top: height * .35,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                height: height * .65,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                    color: theme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    )),
                child: WidgetMotion(
                  direction: "right",
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Sign in to your\n',
                            style: GoogleFonts.lexend(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            children: [
                              TextSpan(
                                text: 'MediTouch',
                                style: GoogleFonts.lexend(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary, // Highlight color
                                ),
                              ),
                              TextSpan(
                                text: ' Account',
                                style: GoogleFonts.lexend(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomEmailfield(
                            hint: "Email Address",
                            size: const Size(350, 50),
                            bgColor: theme.primary.withOpacity(.15),
                            fgColor: theme.onSurface,
                            controller: emailController),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomPasswordfield(
                            hint: "Password",
                            size: const Size(350, 50),
                            bgColor: theme.primary.withOpacity(.15),
                            fgColor: theme.onSurface,
                            controller: passwordController),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: theme.error,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomButton(
                            size: Size(350, 50),
                            text: "Sign in",
                            onPressed: () {
                              final String email = emailController.text.trim();
                              final String password = passwordController.text.trim();

                              BlocProvider.of<LoginBloc>(context).add(LoginSubmitted(email: email, password: password));

                            },
                            bgColor: theme.primary,
                            fgColor: theme.onPrimary,
                            isLoading: false),

                        const SizedBox(
                          height: 20,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?"),
                            const SizedBox(width: 8,),
                            GestureDetector(
                              onTap: (){
                                Navigator.of(context).pushNamed('/register');
                              },
                              child: Text("Create an account",style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.primary
                              ),),
                            )
                          ],
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Or",style: TextStyle(
                              color: theme.onSurface.withOpacity(.5)
                            ),),
                          ],
                        ),



                        const SizedBox(
                          height: 20,
                        ),


                        CustomGoogleButton(
                            size: Size(350, 50),
                            text: "Continue with Google",
                            onPressed: () {
                            },
                            bgColor: theme.primary.withOpacity(.2),
                            fgColor: theme.onSurface,
                            isLoading: false),

                      ],
                    ),
                  ),
                ),
              ))
        ],
      )),
    );
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
}
