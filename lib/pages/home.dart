import 'package:flutter/material.dart';
import 'package:hangman/pages/login_screen.dart';
import 'package:hangman/pages/mulitplayer.dart';
import 'package:hangman/pages/singleplayer.dart';
import 'package:hangman/utils/user_controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Builder(
              builder: (context) {
                return InkWell(
                  child: CircleAvatar(
                    foregroundImage:
                        NetworkImage(UserController.user?.photoURL ?? ''),
                  ),
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
          ),
        ),
        drawer: Drawer(
          backgroundColor: const Color(0xff2c2c2c),
          child: ListView(
            children: [
              DrawerHeader(
                child: Column(children: [
                  CircleAvatar(
                    radius: 52,
                    foregroundImage:
                        NetworkImage(UserController.user?.photoURL ?? ''),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    UserController.user?.displayName ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                ]),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await UserController.signOut();
                      if (mounted) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ));
                      }
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    child: const Text(
                      "Log Out",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/hangman.png'),
              SizedBox(
                width: 240,
                height: 80,
                child: FittedBox(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Singleplayer()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(10, 50),
                        backgroundColor: Colors.black),
                    child: const Text(
                      "Singleplayer",
                      style: TextStyle(
                          fontFamily: 'Press-Start-2P',
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffae0001)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 240,
                height: 80,
                child: FittedBox(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Multiplayer()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(10, 50),
                        backgroundColor: Colors.black),
                    child: const Text(
                      "Multiplayer",
                      style: TextStyle(
                          fontFamily: 'Press-Start-2P',
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffae0001)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
