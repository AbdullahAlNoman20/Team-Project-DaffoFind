import 'package:flutter/material.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';

class ChatWithAI extends StatefulWidget {
  const ChatWithAI({super.key});

  @override
  _ChatWithAIState createState() => _ChatWithAIState();
}

class _ChatWithAIState extends State<ChatWithAI> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final String _apiKey =
      "YOUR_GEMINI_API_KEY"; // Replace with your Gemini API key
  // late GenerativeModel _model;

  @override
  void initState() {
    super.initState();
    // _model = GenerativeModel(model: "gemini-pro", apiKey: _apiKey);
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    setState(() {
      _messages.add({"user": _messageController.text});
    });

    // final response = await _model.generateContent([_messageController.text]);
    setState(() {
      // _messages.add({"ai": response.text ?? "No response"});
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat with AI")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final entry = _messages[index];
                return ListTile(
                  title: Text(entry.keys.first == "user"
                      ? "You: ${entry["user"]}"
                      : "AI: ${entry["ai"]}"),
                  tileColor: entry.keys.first == "user"
                      ? Colors.blue[100]
                      : Colors.green[100],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration:
                        const InputDecoration(labelText: "Enter your message"),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
