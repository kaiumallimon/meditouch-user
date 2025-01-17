import 'package:flutter/material.dart';
import 'package:meditouch/common/widgets/custom_loading_animation.dart';
import 'package:meditouch/features/dashboard/features/doctors/presentation/screens/doctor_search_screen.dart';
import 'package:quickalert/quickalert.dart';
import 'package:meditouch/features/ai-chat/data/repository/ai_chat_repository.dart';
import 'package:hive/hive.dart';

class AiModelChatScreen extends StatefulWidget {
  const AiModelChatScreen({Key? key}) : super(key: key);

  @override
  State<AiModelChatScreen> createState() => _AiModelChatScreenState();
}

class _AiModelChatScreenState extends State<AiModelChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final AiChatRepository _repository = AiChatRepository();
  bool _isLoading = false;

  late Box _chatBox;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMessages();

    // Scroll to bottom when the page is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _saveMessages();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();  // Dispose the scroll controller
    super.dispose();
  }

  Future<void> _loadMessages() async {
    _chatBox = Hive.box('chatMessages');
    final storedMessages = _chatBox.get('messages', defaultValue: []);
    setState(() {
      _messages.addAll(List<Map<String, dynamic>>.from(storedMessages));
    });

    // Ensure scroll to bottom when new messages are loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  Future<void> _saveMessages() async {
    await _chatBox.put('messages', _messages);
  }

  void _sendMessage(String message) async {
    setState(() {
      _messages.add({
        'sender': 'user',
        'text': message,
        'timestamp': DateTime.now().toIso8601String(),
      });
      _isLoading = true;
    });

    await _saveMessages();  // Save user message to Hive

    final response = await _repository.getChatResponse(message);

    setState(() {
      if (response != null && response.containsKey('response')) {
        _messages.add({
          'sender': 'ai',
          'text': response['response'] ?? 'No response available.',
          'suggested_doctors': response['suggested_doctors'] ?? [],
          'timestamp': DateTime.now().toIso8601String(),
        });
      } else {
        _messages.add({
          'sender': 'ai',
          'text': 'Failed to get a response. Please try again.',
          'timestamp': DateTime.now().toIso8601String(),
        });
      }
      _isLoading = false;
    });

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    await _saveMessages();  // Save AI response to Hive
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('AI Chat'),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        surfaceTintColor: Theme.of(context).colorScheme.surfaceContainer,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Messages display area
            Expanded(
              child: _messages.isEmpty
                  ? const Center(
                child: Text(
                  'Start chatting with our very own AI model!',
                  style: TextStyle(color: Colors.grey),
                ),
              )
                  : ListView.builder(
                physics: const BouncingScrollPhysics(),
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 20),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUser = message['sender'] == 'user';

                  return Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context)
                            .colorScheme
                            .primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message['text'] ?? '',
                            style: TextStyle(
                              color: isUser
                                  ? Colors.white
                                  : Theme.of(context)
                                  .colorScheme
                                  .onSurface,
                            ),
                          ),
                          if (!isUser &&
                              message['suggested_doctors'] != null)
                            const SizedBox(height: 10),
                          if (!isUser &&
                              message['suggested_doctors'] != null)
                            ...?List<String>.from(
                                message['suggested_doctors']
                                as List<dynamic>)
                                .map(
                                  (doctor) => GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DoctorSearchScreen(
                                                searchQuery: doctor,
                                              )));  // Navigate to doctor search
                                },
                                child: Container(
                                  margin:
                                  const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary,
                                    borderRadius:
                                    BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        doctor,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      const Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.black,
                                        size: 15,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_isLoading)
              Padding(
                padding: EdgeInsets.all(10.0),
                child: CustomLoadingAnimation(
                    size: 25, color: Theme.of(context).colorScheme.primary),
              ),
            // Chat input
            _buildChatInput(context),
          ],
        ),
      ),
    );
  }

  Widget _buildChatInput(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(color: theme.primaryContainer),
      child: Row(
        children: [
          // Text input
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: theme.surface,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                maxLines: 2,
                minLines: 1,
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  hintStyle: TextStyle(color: theme.onSurface.withOpacity(0.5)),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
          // Send button
          IconButton(
            onPressed: () {
              final message = _controller.text.trim();
              if (message.isNotEmpty) {
                _controller.clear();
                _sendMessage(message);
              } else {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.error,
                  title: 'Error',
                  text: 'Message cannot be empty',
                );
              }
            },
            icon: Icon(
              Icons.send,
              color: theme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
