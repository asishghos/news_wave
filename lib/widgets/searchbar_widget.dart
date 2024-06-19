import 'package:flutter/material.dart';
import 'package:indian_news/service/search_bar_service.dart';

class SearchbarWidget extends StatefulWidget {
  const SearchbarWidget({super.key});
  static TextEditingController searchcontroller =
      TextEditingController(text: '');

  @override
  _SearchbarWidgetState createState() => _SearchbarWidgetState();
}

class _SearchbarWidgetState extends State<SearchbarWidget> {
  final AllNewsService _newsService = AllNewsService();

  void _searchNews() {
    FocusScope.of(context).unfocus();
    _newsService.fetchAllNews(SearchbarWidget.searchcontroller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      controller: SearchbarWidget.searchcontroller,
                      decoration: InputDecoration(
                        hintText: 'Search a keyword',
                        hintStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await _searchNews;
                    },
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                          color: Colors.grey, shape: BoxShape.circle),
                      child: Icon(
                        Icons.search_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
