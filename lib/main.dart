import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hangman/firebase_options.dart';
import 'package:hangman/pages/home.dart';
import 'package:hangman/pages/host_room.dart';
import 'package:hangman/pages/join_room.dart';
import 'package:hangman/pages/login_screen.dart';
import 'package:hangman/pages/multiplayer_gamescreen.dart';
import 'package:hangman/provider/game_state_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GameStateProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hangman',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.amber,
            primary: const Color(0xffae0001),
            onSurface: Colors.white,
          ),
          scaffoldBackgroundColor: const Color(0xff1e1e1e),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xffae0001),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              textStyle: const TextStyle(
                  fontFamily: 'Press-Start-2P',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          cardTheme: CardTheme(
            color: const Color(0xff2c2c2c),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          dialogTheme: const DialogTheme(
            backgroundColor: Color(0xff2c2c2c),
            titleTextStyle:
                TextStyle(color: Colors.white, fontFamily: 'Press-Start-2P'),
            contentTextStyle:
                TextStyle(color: Colors.white70, fontFamily: 'Press-Start-2P'),
          ),
          appBarTheme: const AppBarTheme(
            color: Color(0xff212121),
            titleTextStyle: TextStyle(
              fontFamily: 'Press-Start-2P',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xff212121),
            selectedItemColor: Colors.amber,
            unselectedItemColor: Colors.white70,
          ),
        ),
        home: const Auth(),
        routes: {
          '/home': (context) => const Home(),
          '/host-room': (context) => const HostRoom(),
          '/join-room': (context) => const JoinRoom(),
          '/game-screen': (context) => const GameScreen(),
        },
      ),
    );
  }
}

class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return const Home();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
