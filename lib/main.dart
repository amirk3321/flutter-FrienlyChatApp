import 'package:flutter/material.dart';

void main() => runApp(FriendlyChat());

class FriendlyChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Friendly Chat",
      home: new ChatScreen(),
    );
  }
} //end FriendlyChat

//child ChatScreen widget that can rebuild
// when messages are sent and internal state changes
class ChatScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChatScreenState();
} //end ChatScreen

//if you want to visually present stateful data in a widget,
// you should encapsulate this data in a State object.
// You can then associate your State object with a widget
//that extends the StatefulWidget class.
class ChatScreenState extends State<ChatScreen> {
  final List<ChatMassage> _massage = <ChatMassage>[];
  final TextEditingController _textEditingController =
      new TextEditingController();

  void _handleSubmitted(String msg) {
    _textEditingController.clear();
    ChatMassage massage = new ChatMassage(text: msg);
    // Only synchronous operations should be performed in setState()
    //because otherwise the framework could rebuild the widgets before the operation finishes.
    setState(() {
      _massage.insert(0, massage);
    });
  } //end _handleSubmitted

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _textEditingController,
              onSubmitted: _handleSubmitted,
              decoration: InputDecoration.collapsed(hintText: "Sent massage.."),
            ),
          ), //new end flexible
          new Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: new IconButton(
                icon: new Icon(Icons.send),
                color: Colors.blue,
                onPressed: () => _handleSubmitted(_textEditingController.text)),
          ),
        ],
      ),
    );
  } //end _textEditingController

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Friendly Chat"),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              itemBuilder: (_, int index) => _massage[index],
              itemCount: _massage.length,
              reverse: true,
              padding: EdgeInsets.all(8.0),
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor
            ),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
} //end ChatScreenState

class ChatMassage extends StatelessWidget {
  ChatMassage({this.text});

  final String text;
  String _name = "amir";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            child: CircleAvatar(
              child: new Text(_name[0]),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(_name, style: Theme.of(context).textTheme.subhead),
              Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: Text(text),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
