![MediTouch Logo](https://github.com/kaiumallimon/appf-assets/raw/main/app-icon-128.png)

# MediTouch

MediTouch is a groundbreaking initiative aimed at transforming healthcare delivery by providing comprehensive healthcare services to remote and underserved areas through a simple, user-friendly app. The system is to reach the rural areas of Bangladesh and solve pressing medical issues. MediTouch aims to reduce healthcare costs by offering affordable solutions and minimising unnecessary travel to healthcare facilities. By leveraging advanced technology, MediTouch enhances the quality and efficiency of healthcare services, ensuring that every individual receives optimal care. Additionally, MediTouch is committed to healthcare education, awareness, empowering the public with vital information to promote healthy living and proactive health management.


### What's the vision of MediTouch?

Meditouch mainly aims to provide medical service in rural areas by -
- Reducing Cost
- Hasslefree service
- Fast response

### What MediTouch offers?
Residents of rural areas often face significant challenges in accessing medical consultations with senior doctors. They typically need to travel to district towns or the capital, often enduring long waits for appointments.

*MediTouch Provides:*

**Local Accessibility**: 
MediTouch brings medical services closer to rural areas, reducing the need for long-distance travel.

**Easy Appointment Booking**: 
Patients can effortlessly schedule appointments with their desired doctors using the MediTouch platform.

**Video Consultations**: 
Patients can have video calls with senior doctors, ensuring they receive the necessary medical advice and prescriptions from the comfort of their homes.

**Comprehensive Medical Services**: Through MediTouch, patients can get the same level of medical care they would receive in urban centres, including proper diagnoses and treatment plans.

**Emergency Support**:
In case of an emergency, users can request ambulance through MediTouch.

**Medication and Health Check-Up Reminders**: 
MediTouch offers medication and check-up reminders to help users stay on top of their health by providing medication and check-up reminders. 

**Community Features**: 
MediTouch offers a vibrant community platform where users can engage with doctors or other users through posting their thoughts or commenting on posts. 

**Nurse Hiring**: Users can book a nurse for their required duration to meet their specific needs.


## Tools/Technologies

*Platform*: Mobile Application

*Frontend*: Flutter

*Backend*: Firebase & Node.js

*Primary DB*: MongoDB

*Secondary DB*: Hive (based on sqlite)

*Payment Gateway*: Bkash

## Project Structure

```bash
meditouch-user
│   lib
│   ├── common
│   │   ├── repository
│   │   │   └── hive_repository.dart
│   │   ├── themes
│   │   │   └── theme.dart
│   │   ├── utils
│   │   │   └── datetime_format.dart
│   │   └── widgets
│   │       ├── custom_appbar.dart
│   │       ├── custom_button.dart
│   │       ├── custom_list_tile.dart
│   │       ├── custom_tinted_iconbutton.dart
│   │       ├── gradient_bg.dart
│   │       └── widget_motion.dart
│   ├── features
│   │   ├── auth
│   │   │   ├── login
│   │   │   │   ├── data
│   │   │   │   │   └── repository
│   │   │   │   │       └── login_repository.dart
│   │   │   │   ├── logic
│   │   │   │   │   ├── login_bloc.dart
│   │   │   │   │   ├── login_event.dart
│   │   │   │   │   └── login_state.dart
│   │   │   │   ├── presentation
│   │   │   │   │   ├── screens
│   │   │   │   │   │   └── login_screen.dart
│   │   │   │   │   └── widgets
│   │   │   │   │       ├── continue_with_google.dart
│   │   │   │   │       ├── custom_emailfield.dart
│   │   │   │   │       └── custom_passwordfield.dart
│   │   │   │   └── login.dart
│   │   │   └── register
│   │   │       ├── data
│   │   │       │   └── repository
│   │   │       │       ├── email_verifier.dart
│   │   │       │       └── registration_repository.dart
│   │   │       ├── logic
│   │   │       │   ├── date_cubit.dart
│   │   │       │   ├── gender_cubit.dart
│   │   │       │   ├── image_cubit.dart
│   │   │       │   ├── register_bloc.dart
│   │   │       │   ├── register_event.dart
│   │   │       │   └── register_state.dart
│   │   │       ├── presentation
│   │   │       │   ├── screens
│   │   │       │   │   └── register_screen.dart
│   │   │       │   └── widgets
│   │   │       │       ├── custom_datepicker.dart
│   │   │       │       ├── custom_genderpicker.dart
│   │   │       │       ├── custom_imagepicker.dart
│   │   │       │       └── custom_textfield_reg.dart
│   │   │       └── register.dart
│   │   ├── dashboard
│   │   │   ├── features
│   │   │   │   ├── account
│   │   │   │   │   ├── logics
│   │   │   │   │   │   ├── account_bloc.dart
│   │   │   │   │   │   ├── account_events.dart
│   │   │   │   │   │   ├── account_states.dart
│   │   │   │   │   │   └── theme_cubit.dart
│   │   │   │   │   └── presentation
│   │   │   │   │       ├── screens
│   │   │   │   │       │   ├── account_screen.dart
│   │   │   │   │       │   └── theme_screen.dart
│   │   │   │   │       └── widgets
│   │   │   │   │           ├── custom_multipletile.dart
│   │   │   │   │           └── custom_tile.dart
│   │   │   │   ├── appointments
│   │   │   │   │   ├── presentation
│   │   │   │   │   │   └── screens
│   │   │   │   │   │       └── appointment_screen.dart
│   │   │   │   │   └── appointments.dart
│   │   │   │   ├── epharmacy
│   │   │   │   │   ├── presentation
│   │   │   │   │   │   └── screens
│   │   │   │   │   │       └── epharmacy_screen.dart
│   │   │   │   │   └── epharmacy.dart
│   │   │   │   ├── home
│   │   │   │   │   ├── logics
│   │   │   │   │   │   ├── home_bloc.dart
│   │   │   │   │   │   ├── home_event.dart
│   │   │   │   │   │   └── home_state.dart
│   │   │   │   │   ├── presentation
│   │   │   │   │   │   └── screens
│   │   │   │   │   │       └── home_screen.dart
│   │   │   │   │   └── home.dart
│   │   │   │   ├── messages
│   │   │   │   │   ├── presentation
│   │   │   │   │   │   └── screens
│   │   │   │   │   │       └── messages_screen.dart
│   │   │   │   │   └── messages.dart
│   │   │   │   └── profile
│   │   │   │       ├── presentation
│   │   │   │       │   └── screens
│   │   │   │       │       └── profile_screen.dart
│   │   │   │       └── profile.dart
│   │   │   ├── navigation
│   │   │   │   ├── logics
│   │   │   │   │   └── navigation_cubit.dart
│   │   │   │   └── navbar
│   │   │   │       └── custom_navbar.dart
│   │   │   └── wrapper
│   │   │       ├── presentation
│   │   │       │   └── screens
│   │   │       │       └── dashboard_screen.dart
│   │   │       └── dashboard.dart
│   │   └── startup
│   │       ├── splash
│   │       │   ├── logics
│   │       │   │   ├── splash_bloc.dart
│   │       │   │   ├── splash_event.dart
│   │       │   │   └── splash_state.dart
│   │       │   ├── presentation
│   │       │   │   └── screens
│   │       │   │       └── splash_screen.dart
│   │       │   └── splash.dart
│   │       └── welcome
│   │           ├── logics
│   │           │   └── welcome_cubit.dart
│   │           ├── presentation
│   │           │   ├── screens
│   │           │   │   └── welcome_screen.dart
│   │           │   └── widgets
│   │           │       ├── textstyles.dart
│   │           │       ├── welcome_log_reg_button.dart
│   │           │       └── welcome_next_button.dart
│   │           └── welcome.dart
│   ├── firebase_options.dart
│   └── main.dart
│   .env
│   .flutter-plugins
│   .flutter-plugins-dependencies
│   .gitignore
│   .metadata
│   analysis_options.yaml
│   architecture.txt
│   firebase.json
│   pubspec.lock
│   pubspec.yaml
│   README.md
```