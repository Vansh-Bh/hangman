import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hangman/firebase_options.dart';
import 'package:hangman/pages/home.dart';
import 'package:hangman/pages/host_room.dart';
import 'package:hangman/pages/join_room.dart';
import 'package:hangman/pages/login_screen.dart';
import 'package:hangman/pages/multiplayer_gamescreen.dart';
import 'package:hangman/provider/client_state_provider.dart';
import 'package:hangman/provider/game_state_provider.dart';
import 'package:hangman/utils/user_controller.dart';
import 'package:http/http.dart';
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
        ChangeNotifierProvider(create: (context) => ClientStateProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hangman',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              background: const Color(0xffae0001), seedColor: Colors.redAccent),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => UserController.user != null ? const Home() : const LoginPage(),
          '/home': (context ) => const Home(),
          '/host-room': (context) => const HostRoom(),
          '/join-room': (context) => const JoinRoom(),
          '/game-screen': (context) => const GameScreen(),
        },
      ),
    );
  }
}
