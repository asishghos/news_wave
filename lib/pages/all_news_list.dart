import 'package:flutter/material.dart';
import 'package:indian_news/models/tending_news_models.dart';
import 'package:indian_news/service/trending_api.dart';
import 'package:indian_news/widgets/card_widget.dart';
import 'package:indian_news/widgets/searchbar_widget.dart';

class AllNewsList extends StatefulWidget {
  @override
  _AllNewsListState createState() => _AllNewsListState();
}

class _AllNewsListState extends State<AllNewsList> {
  late Future<List<Trendingnews>> futureArticles;
  final NewsApiService apiService = NewsApiService();

  @override
  void initState() {
    super.initState();
    futureArticles = apiService.fetchTopHeadlines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        iconTheme: IconThemeData(color: Colors.white, size: 30),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "News ",
              style: TextStyle(color: Colors.white, letterSpacing: 1),
            ),
            Text(
              "Wave",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            )
          ],
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: FutureBuilder<List<Trendingnews>>(
        future: futureArticles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text('No news available',
                    style: TextStyle(color: Colors.white)));
          }
          final articles = snapshot.data!;
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SearchbarWidget(),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return CardWidget(
                      publishedAt: article.publishedAt ?? "",
                      title: article.title ?? 'No title',
                      desc: article.description ?? 'No description',
                      imageUrl: article.urlToImage ??
                          'https://via.placeholder.com/150',
                      url: article.url ?? '',
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AllNewsList(),
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
  ));
}
