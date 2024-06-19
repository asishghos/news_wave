import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indian_news/models/tending_news_models.dart';
import 'package:indian_news/pages/all_news_list.dart';
import 'package:indian_news/service/trending_api.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:indian_news/widgets/card_widget.dart';
import 'package:indian_news/widgets/carouselslider_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

class NewsHomePage extends StatefulWidget {
  @override
  _NewsHomePageState createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
  late Future<List<Trendingnews>> futureArticles;
  final NewsApiService apiService = NewsApiService();
  int _current = 0;
  final CarouselController _controller = CarouselController();

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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "News ",
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
            Text(
              "Wave",
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1),
            )
          ],
        ),
        centerTitle: true,
        elevation: 5.0,
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
                Text(
                  "Breaking News!",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                    fontSize: 22.0,
                  ),
                ),
                SizedBox(height: 10),
                CarouselSlider.builder(
                  carouselController: _controller,
                  itemCount: articles.length,
                  itemBuilder: (context, index, realIndex) {
                    final article = articles[index];
                    return CarouselsliderWidget(
                      image: article.urlToImage ??
                          'https://via.placeholder.com/150',
                      index: index,
                      name: article.title ?? 'No title',
                      url: article.url ?? '',
                    );
                  },
                  options: CarouselOptions(
                    height: 250,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    },
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                SizedBox(height: 10),
                AnimatedSmoothIndicator(
                  activeIndex: _current,
                  count: articles.length,
                  effect: ScrollingDotsEffect(
                    dotWidth: 8.0,
                    dotHeight: 8.0,
                    activeDotColor: Colors.blue,
                    dotColor: Colors.grey,
                  ),
                  onDotClicked: (index) {
                    _controller.animateToPage(index);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Trending News!",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 22.0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => AllNewsList()));
                        },
                        child: Text(
                          "View All",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue,
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 10,
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
    home: NewsHomePage(),
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
  ));
}
