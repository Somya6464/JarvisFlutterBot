import 'package:chatbot_app/messages.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  late DialogFlowtter dialogFlowtter;
  final searchController = TextEditingController();

  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    DialogFlowtter.fromFile().then(
      (instance) => dialogFlowtter = instance,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:const Color.fromARGB(255, 158, 97, 202),
          title: const Text(
            "Jarvis Flutter Bot",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
        body: SizedBox(
          child: Column(
            children: [
              Expanded(child: MessagesScreen(messages: messages)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                          hintText: "Talk With me..",
                          hintStyle: TextStyle(color: Colors.grey[850]),
                          filled: true,
                          fillColor: const Color.fromARGB(207, 49, 14, 73),
                          focusedBorder: OutlineInputBorder(
                              borderSide:const  BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(30)),
                          suffixIcon: IconButton(
                            onPressed: () {
                              sendMessage(searchController.text);
                              searchController.clear();
                            },
                            icon: const Icon(Icons.send, color: Colors.white),
                          ),
                          border: OutlineInputBorder(
                              borderSide:const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(30))),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  sendMessage(String text) async {
    if (text.isEmpty) {
      debugPrint('Message is empty');
    } else {
      setState(() {
        addMessage(Message(text: DialogText(text: [text])), true);
      });

      DetectIntentResponse response = await dialogFlowtter.detectIntent(
          queryInput: QueryInput(text: TextInput(text: text)));
      if (response.message == null) return;
      setState(() {
        addMessage(response.message!);
      });
    }
  }

  addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({'message': message, 'isUserMessage': isUserMessage});
  }
}
