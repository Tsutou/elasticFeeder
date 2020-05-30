class NewsJson{
  String status;
  String totalResults;
  List<News> articles;

  NewsJson.fromJson(Map<String, dynamic> json){
    status = json['status'];
    totalResults = json['totalResults'];
    articles = json['articles'];
  }
}

class News {
  Source source;
  String author;
  String title;
  String description;
  String url;
  String urlToImage;
  String publishedAt;
  String content;

  News.fromJson(Map<String, dynamic> json) {
    source = json['source'];
    author = json['author'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
    urlToImage = json['urlToImage'];
    publishedAt = json['publishedAt'];
    content = json['content'];
  }
}

class Source {
  String id;
  String name;

  Source.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}
