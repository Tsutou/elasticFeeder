import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'news.dart';

void main() => runApp(ElasticFeederApp());

class ElasticFeederApp extends StatefulWidget {
  ElasticFeederApp({Key key}) : super(key: key);

  @override
  _ElasticFeederAppState createState() => _ElasticFeederAppState();
}

class _ElasticFeederAppState extends State<ElasticFeederApp> {
  List<News> _newsList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Erastic Feeder',
        theme: ThemeData(
          primarySwatch: Colors.lime,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildInput(),
                Expanded(child: _buildNewsList())
              ],
            ),
          ),
        ));
  }

  Widget _buildInput() {
    return Container(
      margin: EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: "Please enter a News keyword",
          labelText: "search",
        ),
        onChanged: (inputString) {
          if (inputString.length >= 3) {
            _searchRepo(inputString).then((values) {
              setState(() {
                _newsList = values;
              });
            });
          }
        },
      ),
    );
  }

  Widget _buildNewsList() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        final news = _newsList[index];
        return _buildCard(news);
      },
      itemCount: _newsList.length,
    );
  }

  Widget _buildCard(News news) {
    return Card(
      margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              news.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          ),
          news.source != null
              ? Padding(
                  padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
                  child: Text(
                    news.source.name,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                  ),
                )
              : Container(),
          news.description != null
              ? Padding(
                  padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
                  child: Text(news.description,
                      style: TextStyle(
                          fontWeight: FontWeight.w200, color: Colors.grey)),
                )
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(Icons.date_range),
              SizedBox(
                width: 50.0,
                child: Text(news.publishedAt.toString()),
              ),
              Icon(Icons.people),
              SizedBox(
                width: 50.0,
                child: Text(news.author.toString()),
              ),
            ],
          ),
          SizedBox(
            height: 16.0,
          )
        ],
      ),
    );
  }
}

Future<List<News>> _searchRepo(String searchWord) async {
  final response = await http.get("http://newsapi.org/v2/everything?q=" +
      searchWord +
      "&sortBy=publishedAt&apiKey=b31ef555b6b4431f80efb22f86afbf30");
  if (response.statusCode == 200) {
    Map<String, dynamic> decoded = json.decode(response.body);
    var data = NewsJson.fromJson(decoded);
    return data.articles;
  } else {
    throw Exception('Fail to search repository');
  }
}
