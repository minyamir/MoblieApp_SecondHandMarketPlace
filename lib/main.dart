import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import DI
import 'core/di/injection_container.dart' as di;

// Import Providers
import 'features/auth/presentation/provider/auth_provider.dart';
import 'features/listings/presentation/provider/listings_provider.dart';
import 'features/verification/presentation/provider/verification_provider.dart';

// Import Screens
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/listings/presentation/screens/listings_screen.dart';
import 'features/verification/presentation/screens/verification_screen.dart';


import 'features/home/presentation/screens/home_screen.dart'; // Adjust path if needed
import 'features/home/home_injection.dart'; // Import Home feature DI setup
import 'features/home/presentation/provider/home_provider.dart';
void main() async {
  // 1. Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Dependency Injection (sl)
  await di.init();

  runApp(const HaHuMarketApp());
}

class HaHuMarketApp extends StatelessWidget {
  const HaHuMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // 3. Connect UI to your Clean Architecture Logic
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<ListingsProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<VerificationProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<HomeProvider>()),
      ],
      child: MaterialApp(
        title: 'HaHu Market',
        debugShowCheckedModeBanner: false,
        
        // 4. App Theme (Bahir Dar / Ethiopia Green Style)
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            primary: Colors.green[700],
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.green[700],
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        ),

        // 5. Navigation Routes
        // We start at Login. Once logged in, we move to Home.
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/verification': (context) => const VerificationScreen(),
          '/register': (context) => const RegisterScreen(),
        },
      ),
    );
  }
}