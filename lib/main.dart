import 'package:com_akdemix/src/common_screens/home/home_page.dart';
import 'package:com_akdemix/src/common_widgets/error_page.dart';
import 'package:com_akdemix/src/features/authentication/global_provider.dart';
import 'package:com_akdemix/src/features/authentication/route/app_router.dart';
import 'package:com_akdemix/src/features/authentication/screens/sign_in_landing_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) => AppRouter.onGenerateRoute(settings),
      initialRoute: AppRoutes.startupPage,
      title: 'Akdemix',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const WelcomeScreen(),
    );
  }
}

class StartupPage extends ConsumerWidget {
  const StartupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateChanges = ref.watch(authStateChangesProvider);
    return authStateChanges.when(
      data: (user) {
        if (user != null) {
          return const HomePage();
        } else {
          return const SignInLandingPage();
        }
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, _) => ErrorPage(message: error.toString()),
    );
  }
}
