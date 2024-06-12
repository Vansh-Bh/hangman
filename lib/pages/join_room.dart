import 'package:flutter/material.dart';
import 'package:hangman/utils/socket_method.dart';
import 'package:hangman/widgets/custom_button.dart';
import 'package:hangman/widgets/custom_text.dart';

class JoinRoom extends StatefulWidget {
  const JoinRoom({super.key});

  @override
  State<JoinRoom> createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> {
  final _nameController = TextEditingController();
  final _gameIdController = TextEditingController();
  final SocketMethods _socketMethods = SocketMethods();

  @override
  void initState() {
    super.initState();
    _socketMethods.updateGameListener(context);
    _socketMethods.notCorrectGameListener(context);
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _gameIdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: Container(
            margin: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Join Room",
                  style: TextStyle(
                    fontFamily: 'Press-Start-2P',
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                CustomTextField(
                    controller: _nameController,
                    hintText: "Enter your nickname"),
                const SizedBox(
                  height: 24,
                ),
                CustomTextField(
                    controller: _gameIdController, hintText: "Enter Code"),
                const SizedBox(
                  height: 24,
                ),
                CustomButton(
                  text: "Join",
                  onTap: () => _socketMethods.joinGame(
                      _gameIdController.text, _nameController.text),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
