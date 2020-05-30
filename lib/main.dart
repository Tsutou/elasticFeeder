import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'News.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Erastic Feeder',
      theme: ThemeData(
        primarySwatch: Colors.lime,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
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

          });
        }
      },
    ),
  );
}

Widget _buildRepositoryList(){
  
}

Future<List<News>> _searchRepo(String searchWord) async {
  final response = await http.get("http://newsapi.org/v2/everything?q=" + searchWord + "&from=2020-04-30&sortBy=publishedAt&apiKey=");
  if(response.statusCode == 200){
    List<News> list = [];
    Map<String,dynamic> decoded = json.decode(response.body);
    for (var article in decoded["articles"]) {
      list.add(News.fromJson(article));
    }
    return list;
  } else {
    throw Exception('Fail to search repository');
  }
}
