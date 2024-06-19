import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:indian_news/models/tending_news_models.dart';

class NewsApiService {
  final String apiKey = 'YOUR_API_KEY';
  final String baseUrl = 'https://newsapi.org/v2/top-headlines';

  Future<List<Trendingnews>> fetchTopHeadlines() async {
    final response = await http.get(Uri.parse('https://newsapi.org/v2/everything?q=india&apiKey=c4b7d2756d524c33b1236ed694ef01cc'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> articles = data['articles'] as List<dynamic>;

      return articles.map((json) => Trendingnews.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}
