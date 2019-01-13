import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(new MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primaryColor: Colors.redAccent,
      ),
      home: new RandomWords(),
    );
  }
}
class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}
class RandomWordsState extends State<RandomWords> {
  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _saved = new Set<WordPair>();
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('English Words Generator'),



        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }
  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (BuildContext _context, int i) {
          if (i.isOdd) {
            return const Divider();
          }
          final int index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(15));
          }
          return _buildRow(_suggestions[index]);
        });
  }



  Widget _buildRow(WordPair pair) {



    new Card(
      child: new Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
      new Container(
      width: 200.0,
        height: 200.0,
      ),
      FractionalTranslation(
        translation: Offset(0.0, 0.5),
        child: new Container(
          alignment: new FractionalOffset(0.0, 0.0),
          decoration: new BoxDecoration(
            border: new Border.all(
              color: Colors.blue.withOpacity(0.5),
              width: 50.0,
            ),
            shape: BoxShape.circle,
          ),
        ),
      )],
      ),
    );


    final bool alreadySaved = _saved.contains(pair);
    return new ListTile(
      title: new Text(
        pair.asCamelCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),

      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );


  }
  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
                (WordPair pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final List<Widget> divided = ListTile
              .divideTiles(
            context: context,
            tiles: tiles,
          )
              .toList();
          return new Scaffold(
            appBar: new AppBar(
              title: const Text('Saved words'),
            ),



            body: new ListView(children: divided),

          );
        },
      ),
    );
  }
}