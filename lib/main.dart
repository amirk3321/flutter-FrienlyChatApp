import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

void main() => runApp(FriendlyChat());

class FriendlyChat extends StatelessWidget {
  final ThemeData kIOSTheme = new ThemeData(
      primarySwatch: Colors.orange,
      primaryColor: Colors.grey[100],
      primaryColorBrightness: Brightness.light);
  final ThemeData KDefaultTheme = new ThemeData(
      primarySwatch: Colors.purple, accentColor: Colors.orangeAccent[400]);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Friendly Chat",
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : KDefaultTheme,
      color: Theme.of(context).accentColor,
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
class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMassage> _massage = <ChatMassage>[];
  bool _isConpose = false;

  final TextEditingController _textEditingController =
      new TextEditingController();

  @override
  void dispose() {
    for (ChatMassage massage in _massage) {
      massage.animationController.dispose();
    }

    super.dispose();
  }

  void _handleSubmitted(String msg) {
    _textEditingController.clear();
    setState(() {
      _isConpose = false;
    });
    ChatMassage massage = new ChatMassage(
      text: msg,
      animationController: AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 700),
          animationBehavior: AnimationBehavior.preserve),
    );
    // Only synchronous operations should be performed in setState()
    //because otherwise the framework could rebuild the widgets before the operation finishes.
    setState(() {
      _massage.insert(0, massage);
    });
    massage.animationController.forward();
  } //end _handleSubmitted

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).backgroundColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textEditingController,
                onSubmitted: _handleSubmitted,
                onChanged: (String msg) {
                  setState(() {
                    _isConpose = msg.length > 0;
                  });
                },
                style: TextStyle(color: Colors.red),
                cursorColor: Colors.red,
                decoration:
                    InputDecoration.collapsed(hintText: "Sent massage.."),
              ),
            ), //new end flexible
            new Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Theme.of(context).platform == TargetPlatform.iOS
                  ? CupertinoButton(
                      child: Text("Send"),
                      onPressed: _isConpose
                          ? () => _handleSubmitted(_textEditingController.text)
                          : null)
                  : IconButton(
                      disabledColor: Colors.red,
                      icon: new Icon(Icons.send),
                      color: Colors.blue,
                      onPressed: _isConpose
                          ? () => _handleSubmitted(_textEditingController.text)
                          : null,
                    ),
            ),
          ],
        ),
      ),
    );
  } //end _textEditingController

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Friendly Chat"),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
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
          Divider(height: 2.0),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
} //end ChatScreenState

class ChatMassage extends StatelessWidget {
  ChatMassage({this.text, this.animationController});

  final String text;
  final AnimationController animationController;
  String _name = "amir";

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
          parent: animationController, curve: Curves.easeInBack),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                child: Text(_name[0]),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_name, style: Theme.of(context).textTheme.subhead),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Text(text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
