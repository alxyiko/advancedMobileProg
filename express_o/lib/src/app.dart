import 'package:express_o/src/sample_feature/login.dart';
import 'package:express_o/src/settings/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'sample_feature/sample_item_details_view.dart';
import 'sample_feature/sample_item_list_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
    required this.authController,
  });

  final SettingsController settingsController;
  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    // Listen to both controllers so theme & auth updates rebuild MaterialApp
    return AnimatedBuilder(
      animation: Listenable.merge([settingsController, authController]),
      builder: (context, _) {
        return MaterialApp(
          restorationScopeId: 'app',

          // Localization
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English
          ],

          // Dynamic app title
          onGenerateTitle: (context) =>
              AppLocalizations.of(context)!.appTitle,

          // Theme handling
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,

          // Handle routing
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);

                  case SampleItemDetailsView.routeName:
                    return const SampleItemDetailsView();

                  // Root route or home route
                  case SampleItemListView.routeName:
                  case '/':
                    if (authController.isLoggedIn) {
                      return const SampleItemListView();
                    } else {
                      return LoginView(authController: authController);
                    }

                  default:
                    return const Scaffold(
                      body: Center(child: Text('404 - Page not found')),
                    );
                }
              },
            );
          },
        );
      },
    );
  }
}
