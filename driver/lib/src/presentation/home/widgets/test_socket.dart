import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class TestSocket extends StatefulWidget {
  const TestSocket({super.key});

  @override
  State<TestSocket> createState() => _TestSocketState();
}

class _TestSocketState extends State<TestSocket> {
  late IO.Socket socket;
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _roomController = TextEditingController();
  String currentRoom = '';
  List<String> messages = [];
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    _connectSocket();
  }

  @override
  void dispose() {
    socket.disconnect();
    _messageController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  void _connectSocket() {
    // Kết nối đến server Socket.IO
    socket = IO.io('http://138.197.136.45:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    // Xử lý sự kiện kết nối
    socket.onConnect((_) {
      setState(() {
        isConnected = true;
        messages.add('🟢 Đã kết nối thành công: ${socket.id}');
      });
      print('Đã kết nối thành công: ${socket.id}');
    });

    // Xử lý khi nhận tin nhắn
    socket.on('receive_message', (data) {
      setState(() {
        messages.add('📩 ${data['sender']}: ${data['message']}');
      });
      print('Nhận tin nhắn: $data');
    });

    // Xử lý khi mất kết nối
    socket.onDisconnect((_) {
      setState(() {
        isConnected = false;
        messages.add('🔴 Đã ngắt kết nối');
      });
      print('Đã ngắt kết nối');
    });

    // Xử lý lỗi
    socket.onError((error) {
      setState(() {
        messages.add('❌ Lỗi kết nối: $error');
      });
      print('Lỗi kết nối: $error');
    });

    // Kết nối
    socket.connect();
  }

  void _joinRoom() {
    if (_roomController.text.isNotEmpty) {
      // Rời khỏi phòng hiện tại nếu đang ở trong một phòng
      if (currentRoom.isNotEmpty) {
        socket.emit('leave_room', currentRoom);
        setState(() {
          messages.add('👋 Đã rời khỏi phòng: $currentRoom');
          currentRoom = '';
        });
      }

      // Tham gia phòng mới
      final room = _roomController.text.trim();
      socket.emit('join_room', room);
      setState(() {
        currentRoom = room;
        messages.add('🚪 Đã tham gia phòng: $room');
      });
    }
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty && currentRoom.isNotEmpty) {
      final message = _messageController.text.trim();
      final data = {
        'room': currentRoom,
        'message': message,
        'sender': socket.id,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      socket.emit('send_message', data);
      setState(() {
        messages.add('📤 Bạn: $message');
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Socket.IO'),
        backgroundColor: Colors.blue,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isConnected ? Colors.green : Colors.red,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _roomController,
                    decoration: InputDecoration(
                      hintText: 'Nhập ID phòng',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _joinRoom,
                  child: const Text('Tham gia'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(messages[index]),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    enabled: currentRoom.isNotEmpty,
                    decoration: InputDecoration(
                      hintText: currentRoom.isEmpty
                          ? 'Hãy tham gia phòng trước'
                          : 'Nhập tin nhắn',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: currentRoom.isEmpty ? null : _sendMessage,
                  child: const Text('Gửi'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
