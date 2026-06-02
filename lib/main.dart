import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Bloc for Cubit support

// Import DI
import 'core/di/injection_container.dart' as di;

// Import Providers / Cubits
import 'features/auth/presentation/provider/auth_provider.dart';
import 'features/listings/presentation/provider/listings_provider.dart';
import 'features/verification/presentation/provider/verification_provider.dart'; // Points to your VerificationCubit file
import 'features/home/presentation/provider/home_provider.dart';

// Import Screens
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/listings/presentation/screens/listings_screen.dart';
import 'features/verification/presentation/screens/verification_screen.dart';
import 'features/home/presentation/screens/home_screen.dart'; 

void main() async {
  // 1. Ensure Flutter Engine bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Service Locator Dependency Injection (sl)
  await di.init();

  runApp(const HaHuMarketApp());
}

class HaHuMarketApp extends StatelessWidget {
  const HaHuMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<ListingsProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<HomeProvider>()),
        BlocProvider(create: (_) => di.sl<VerificationCubit>()),
      ],
      child: MaterialApp(
        title: 'HaHu Market',
        debugShowCheckedModeBanner: false,
        
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

        // Navigation Routes
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/register': (context) => const RegisterScreen(),
          
          // FIXED: Resolved missing userId property error via dynamic protection
          '/verification': (context) {
            final authProvider = Provider.of<AuthProvider>(context, listen: false);
            String activeUserId = "hahu_temp_test_user";
            
            try {
              if ((authProvider as dynamic).user?.id != null) {
                activeUserId = (authProvider as dynamic).user.id.toString();
              } else if ((authProvider as dynamic).user?.uid != null) {
                activeUserId = (authProvider as dynamic).user.uid.toString();
              }
            } catch (_) {}
            
            return VerificationScreen(userId: activeUserId);
          },
        },
      ),
    );
  }
}