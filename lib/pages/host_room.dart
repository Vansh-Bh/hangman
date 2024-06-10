import 'package:flutter/material.dart';
import 'package:hangman/utils/socket_client.dart';
import 'package:hangman/utils/socket_method.dart';
import 'package:hangman/widgets.dart/custom_button.dart';
import 'package:hangman/widgets.dart/custom_text.dart';

class HostRoom extends StatefulWidget {
  const HostRoom({super.key});

  @override
  State<HostRoom> createState() => _HostRoomState();
}

class _HostRoomState extends State<HostRoom> {
  final _nameController = TextEditingController();
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
                  "Host Room",
                  style: TextStyle(
                    fontFamily: 'Press-Start-2P',
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomTextField(
                    controller: _nameController,
                    hintText: "Enter your nickname"),
                const SizedBox(
                  height: 30,
                ),
                CustomButton(
                    text: "Host",
                    onTap: () =>
                        _socketMethods.createGame(_nameController.text))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
