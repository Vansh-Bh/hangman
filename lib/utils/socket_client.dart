import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketClient {
  IO.Socket? socket;
  static SocketClient? _instance;

  SocketClient._internal() {
    socket = IO.io('https://hangman-g0n5.onrender.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    socket!.connect();
  }

  // SocketClient._internal() {
  //   socket = IO.io('https://localhost:3000', <String, dynamic>{
  //     'transports': ['websocket'],
  //     'autoConnect': true,
  //   });
  //   socket!.connect();
  // }

  static SocketClient get instance {
    _instance ??= SocketClient._internal();
    return _instance!;
  }
}
