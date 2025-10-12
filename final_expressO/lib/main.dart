import 'package:firebase_nexus/Profile/ShowProfile.dart';
import 'package:firebase_nexus/appColors.dart';
import 'package:firebase_nexus/helpers/supabase_helper.dart';
import 'package:firebase_nexus/providers/userProvider.dart';
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

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => NavigationProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
    Provider<SupabaseHelper>(create: (_) => SupabaseHelper()),
  ], child: MyApp()));
}

class MyRouteObserver extends NavigatorObserver {
  String? currentRoute;
  // final mainUser = FirebaseAuth.instance.currentUser;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    currentRoute = route.settings.name;
    print(
        'FunctName: DidPush Current route: ${route.settings.name}'); // Debugging
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    currentRoute = previousRoute?.settings.name;
    print('FunctName: DidPop Back to: ${route.settings.name}'); // Debugging
  }
}

final MyRouteObserver routeObserver = MyRouteObserver();

class MyApp extends StatefulWidget {
  // User? mainUser; // Pass mainUser to MyApp
  const MyApp({
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
    final userProvider = Provider.of<UserProvider>(context);

    if (!userProvider.isLoaded) {
      // userProvider.loadUser(context);
    }

    final user = userProvider.user;

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

        // textTheme: TextTheme(
        //   bodyMedium:
        //       GoogleFonts.rubik(fontSize: 14, color: AppColors.textPrimary),
        //   titleLarge:
        //       GoogleFonts.rubik(fontSize: 24, fontWeight: FontWeight.bold),
        // ),
        fontFamily: 'Quicksand', // <-- global font
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 14, color: AppColors.textPrimary),
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => guardedRoute(context, settings.name),
        );
      },
    );
  }

  // Widget _routeGuard(
  //     String? routeName, Map<String, dynamic>? user, bool isLoaded) {
  //   final isPublicRoute =
  //       ['/', '/tioWelcome', '/tioLogin', '/register'].contains(routeName);

  //   if (isLoaded && user == null && !isPublicRoute) {
  //     print(routeName);
  //     print(isLoaded ? 'isLoaded' : 'not isLoaded');
  //     print(user != null ? 'user' : 'not user');
  //     print(!isPublicRoute ? '!isPublicRoute' : 'not !isPublicRoute');
  //     return const LoginScreen();
  //   }

  //   switch (routeName) {
  //     case '/':
  //       return const Splash();
  //     case '/tioWelcome':
  //       return const WelcomeScreen();
  //     case '/tioLogin':
  //       return const LoginScreen();
  //     case '/login':
  //       return const MainScreen();
  //     case '/register':
  //       return const Register();
  //     case '/home':
  //       return const MainScreen();
  //     case '/profile':
  //       return const ShowProfile();

  //     //Admin pages
  //     case '/adminHome':
  //       return const AdminMainScreen();

  //     case '/adminAnalytics':
  //       return const AdminMainScreen();

  //     case '/adminProducts':
  //       return const AdminMainScreen();

  //     case '/adminOrders':
  //       return const AdminMainScreen();

  //     default:
  //       return const Splash();
  //   }
  // }
}

final Map<String, WidgetBuilder> routes = {
  '/': (_) => const Splash(),
  '/tioWelcome': (_) => const WelcomeScreen(),
  '/tioLogin': (_) => const LoginScreen(),
  '/register': (_) => const Register(),
  '/home': (_) => const MainScreen(),
  '/profile': (_) => const ShowProfile(),
  '/adminHome': (_) => const AdminMainScreen(),
  '/adminAnalytics': (_) => const AdminMainScreen(),
  '/adminProducts': (_) => const AdminMainScreen(),
  '/adminOrders': (_) => const AdminMainScreen(),
};

void safeNavigate(BuildContext context, String route) {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final isPublicRoute =
      ['/', '/tioWelcome', '/tioLogin', '/register'].contains(route);

  if (!isPublicRoute && userProvider.user == null) {
    Navigator.pushNamedAndRemoveUntil(context, '/tioLogin', (r) => false);
  } else {
    Navigator.pushNamed(context, route);
  }
}

Widget guardedRoute(BuildContext context, String? routeName) {
  final userProvider = Provider.of<UserProvider>(context, listen: true);
  final user = userProvider.user;
  final isPublicRoute =
      ['/', '/tioWelcome', '/tioLogin', '/register'].contains(routeName);

  if (!userProvider.isLoaded) {
    userProvider.loadUser(context);
  }

  // Not logged in & not a public page → send to login
  if (user == null && !isPublicRoute) {
    print('triggered the not logged in guard!');
    print("user: ${user} ");
    return const LoginScreen();
  }

  // Logged in → if trying to go to login/welcome, redirect to home
  if (user != null && isPublicRoute) {
    print('triggered the logged in guard!');
    print("user: ${user} ");
    return const MainScreen();
  }

  // Normal case: return the actual page (or fallback)
  final builder = routes[routeName] ?? (_) => const Splash();
  return builder(context);
}
