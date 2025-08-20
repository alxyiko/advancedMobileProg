import 'package:firebase_nexus/PostGoogleRegister.dart';
import 'package:firebase_nexus/Profile/ShowProfile.dart';
import 'package:firebase_nexus/appColors.dart';
import 'package:firebase_nexus/helpers/supabase_helper.dart';
import 'package:firebase_nexus/tioPages/login.dart';
import 'package:firebase_nexus/tioPages/main.dart';
import 'package:firebase_nexus/widgets/admin_main_screen.dart';
import 'package:firebase_nexus/widgets/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/navigation_provider.dart';

import 'Register.dart';
import 'login.dart';
import 'splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  final helper = SupabaseHelper();

// Example: check connection
  final connected = await helper.isConnected();
  print(connected ? "✅ Has something in it" : "❌ EMPTY AF");
  print(dotenv.env['SUPABASE_URL']);
  print(dotenv.env['SUPABASE_ANON_KEY']);

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: MyApp(
          // mainUser: rootUser
          )));
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
  // User? mainUser; // Pass mainUser to MyApp
  MyApp({
    super.key,
    // required this.mainUser
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // User? mainUser; // Store mainUser locally

  @override
  void initState() {
    super.initState();
    // mainUser = widget.mainUser; // Assign the mainUser
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
            borderSide: const BorderSide(color: AppColors.secondary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide:
                const BorderSide(color: AppColors.primaryVariant, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: AppColors.secondaryVariant),
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
            backgroundColor: AppColors.primary, // Button background color
            foregroundColor: AppColors.textPrimary, // Text color
            textStyle: const TextStyle(fontSize: 16), // Button text style
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5), // Rounded corners
            ),
          ),
        ),

        textTheme: TextTheme(
          bodyMedium:
              GoogleFonts.rubik(fontSize: 14, color: AppColors.textPrimary),
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
      case '/tioWelcome':
        return WelcomeScreen();
      case '/tioLogin':
        return const LoginScreen();
      case '/login':
        return const Login();
      case '/register':
        return const Register();
      case '/postGegister':
        return const PostGoogleRegister();
      case '/home':
        return const MainScreen();
      case '/profile':
        return const ShowProfile();

      //Admin pages
      case '/adminHome':
        return const AdminMainScreen();

      case '/adminAnalytics':
        return const AdminMainScreen();

      case '/adminProducts':
        return const AdminMainScreen();

      case '/adminOrders':
        return const AdminMainScreen();

      default:
        return const Splash();
    }
  }
}
