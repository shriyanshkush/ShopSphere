import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';

class ChatFabOverlay extends StatefulWidget {
  final String userId;

  const ChatFabOverlay({super.key, required this.userId});

  @override
  State<ChatFabOverlay> createState() => _ChatFabOverlayState();
}

class _ChatFabOverlayState extends State<ChatFabOverlay> {
  bool _open = false;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_open)
          Positioned(
            right: 16,
            bottom: 90,
            child: Container(
              width: 360,
              height: 480,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [BoxShadow(blurRadius: 18, color: Colors.black12)],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('AI Shopping Assistant'),
                      TextButton(
                        onPressed: () => context.read<ChatBloc>().add(ClearChat()),
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                  Expanded(
                    child: BlocBuilder<ChatBloc, ChatState>(
                      builder: (context, state) {
                        return ListView.builder(
                          itemCount: state.messages.length,
                          itemBuilder: (_, index) {
                            final message = state.messages[index];
                            final isUser = message['role'] == 'user';
                            return Align(
                              alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isUser ? Colors.indigo : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  message['content']?.toString() ?? '',
                                  style: TextStyle(color: isUser ? Colors.white : Colors.black87),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(hintText: 'Ask anything...'),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          final text = _controller.text.trim();
                          if (text.isEmpty) return;
                          context
                              .read<ChatBloc>()
                              .add(SendChatMessage(userId: widget.userId, message: text));
                          _controller.clear();
                        },
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            backgroundColor: Colors.indigo,
            onPressed: () => setState(() => _open = !_open),
            label: Text(_open ? 'Close' : 'Ask AI'),
          ),
        ),
      ],
    );
  }
}
