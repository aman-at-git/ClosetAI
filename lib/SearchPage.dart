import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:staggered_layout/ResponsiveConstraints.dart';
import 'package:staggered_layout/main.dart';

class Post {
  final String title;
  final String description;
  Post(this.title, this.description);
}

class SearchPage extends StatelessWidget {
  Future<List<Post>> search(String search) async {
    await Future.delayed(Duration(seconds: 1));
    return List.generate(search.length, (int index) {
      return Post(
        "Title : $search $index",
        "Description :$search $index",
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: ,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 150, left: 30),
                  child: Text(
                    'Search',
                    style: TextStyle(
                      fontSize: Responsive.height(7, context)
                    ),
                  )),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: SearchBar<Post>(
                  onSearch: search,
                  placeHolder: Center(child: Text('Place trending chips here!')),
                  loader: Text("Searching..."),
                  searchBarStyle: SearchBarStyle(
                    backgroundColor: PrimaryColor,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  onItemFound: (Post post, int index) {
                    return ListTile(
                      title: Text(post.title),
                      subtitle: Text(post.description),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}