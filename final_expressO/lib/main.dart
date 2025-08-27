import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_nexus/DocRequests/ShowAnnoucementPhoto.dart';
import 'package:firebase_nexus/DocRequests/ShowDocApplicationDeets.dart';
import 'package:firebase_nexus/DocRequests/ShowDocList.dart';
import 'package:firebase_nexus/DocRequests/ShowDocRequestDeets.dart';
import 'package:firebase_nexus/DocRequests/ShowDocRequestList.dart';
import 'package:firebase_nexus/DocRequests/ShowProgApplicationList.dart';
import 'package:firebase_nexus/DocRequests/ShowProgList.dart';
import 'package:firebase_nexus/DocRequests/ShowProgramDetails.dart';
import 'package:firebase_nexus/DocRequests/ShowRequirementPhoto.dart';
import 'package:firebase_nexus/DocRequests/ShowRequirements.dart';
import 'package:firebase_nexus/FirebaseOperations/firebaseLogin.dart';
import 'package:firebase_nexus/PostGoogleRegister.dart';
import 'package:firebase_nexus/Profile/ShowProfile.dart';
import 'package:firebase_nexus/ShowAnnouncementDetails.dart';
import 'package:firebase_nexus/ShowHistory.dart';
import 'package:firebase_nexus/ShowNotification.dart';
import 'package:firebase_nexus/widgets/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/navigation_provider.dart';

import 'Register.dart';
import 'home.dart';
import 'login.dart';
import 'splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Wait for FirebaseAuth to initialize
  rootUser = FirebaseAuth.instance.currentUser;

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => NavigationProvider()),
  ], child: MyApp(mainUser: rootUser)));
}

class MyRouteObserver extends NavigatorObserver {
  String? currentRoute;
  // final mainUser = FirebaseAuth.instance.currentUser;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    currentRoute = route.settings.name;
    print('Current route: ${route.settings.name}'); // Debugging
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    currentRoute = previousRoute?.settings.name;
    print('Back to: ${route.settings.name}'); // Debugging
  }
}

final MyRouteObserver routeObserver = MyRouteObserver();

class MyApp extends StatefulWidget {
  User? mainUser; // Pass mainUser to MyApp
  MyApp({super.key, required this.mainUser});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? mainUser; // Store mainUser locally

  @override
  void initState() {
    super.initState();
    mainUser = widget.mainUser; // Assign the mainUser
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue), // Change to your desired color
        useMaterial3: true,

        // scaffoldBackgroundColor: Color(0xFFF4F4F4),
        scaffoldBackgroundColor: Colors.white,

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFEFF2FA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Color(0xFF8F8F8F)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Color(0xFF006644), width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Color(0xFF8F8F8F)),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Color(0xFFFE3300), width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 17, horizontal: 10),
          labelStyle: const TextStyle(color: Color(0xFF8F8F8F)),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF006644), // Button background color
            foregroundColor: Colors.white, // Text color
            textStyle: const TextStyle(fontSize: 16), // Button text style
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5), // Rounded corners
            ),
          ),
        ),

        textTheme: TextTheme(
          bodyMedium:
              GoogleFonts.rubik(fontSize: 14, color: const Color(0xFF3F4147)),
          titleLarge:
              GoogleFonts.rubik(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => _routeGuard(settings.name),
        );
      },
    );
  }

  Widget _routeGuard(String? routeName) {
    // if (routeName == '/home' && mainUser == null) {
    //   print('mainUser');
    //   print(mainUser);
    //   return const Login();
    // }
    // if ((routeName != '/login' && routeName != '/register' && routeName != '/home') && mainUser != null) {
    //   print('User detected in the route guard!');
    //   print(mainUser);
    //   if (Firebaseuserservice.userData?['barangay'] == ' ') {
    //     return const PostGoogleRegister();
    //   }
    // }
    // if ((routeName == '/login' || routeName == '/register') && mainUser != null) {
    //   return const HomePage();
    // }

    switch (routeName) {
      case '/':
        return const Splash();
      case '/login':
        return const MainScreen();
      case '/register':
        return const Register();
      case '/postGegister':
        return const PostGoogleRegister();
      case '/home':
        return const MainScreen();
      case '/profile':
        return const ShowProfile();
      case '/history':
        return ShowHistory();
      case '/notifications':
        return ShowNotification();
      case '/requestList':
        return ShowDocRequests();
      case '/programsList':
        return ShowProgApplicationList();
      case '/viewDocList':
        return const ShowDoclist();
      case '/viewProgList':
        return const ShowProgList();
      case '/viewReqList':
        return const ShowRequirementsList();
      case '/viewProgAppli':
        return const ShowProgramRequirementsList();
      case '/viewReqDeets':
        return const ShowRequestDeets();
      case '/viewProgDeets':
        return const ShowApplicationDeets();
      case '/viewRequirementPhoto':
        return const ShowRequirementPhoto();
      case '/viewAnnoucementPhoto':
        return const ShowAnnoucementphoto();
      case '/viewAnnouncementDeets':
        return const ShowAnnouncementDetails();
      default:
        return const Splash();
    }
  }
}
