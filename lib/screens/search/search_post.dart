import 'package:cstalk_clone/models/post.dart';
import 'package:cstalk_clone/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class SearchPost extends SearchDelegate<String> {

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon:Icon(Icons.clear),
        onPressed:() {
          query = '';
        },
      ),
    ];
  }
  
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }
  
  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder(
      stream: PostService().allPosts,
      builder: (context, snapshot) {

        if (!snapshot.hasData) {

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: CircularProgressIndicator()
              ),
            ],
          );

        } else if (snapshot.data.length == 0) {

          return Column(
            children: <Widget>[
              Text(
                "No Results Found.",
              ),
            ],
          );

        } else {

          List<Post> results = snapshot.data;

          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              
              Post post = results[index];

              if (post.postDetail.toLowerCase().contains(query.toLowerCase())) {

                return ListTile(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/detail', arguments: post);
                    _saveRecentlySearch(post.postDetail);
                  },
                  title: Text(post.postDetail),
                );

              } else {

                return Container();
              }

            },
          );
          
        }
      },
    );
  }
  
  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<List<Post>>(
      stream: PostService().allPosts,
      builder: (context, snapshot) {

        if (snapshot.hasData) {

          List<Post> results = snapshot.data;

          if (query.isEmpty) {
            
            return StreamBuilder<List<String>>(
              stream: RxSharedPreferences.getInstance().getStringListStream('recentlySearchList'),
              builder: (context, snapshot) {

                if (snapshot.hasData) {

                  List<String> recentlySearch = snapshot.data;
                  
                  return ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      
                      Post post = results[index];

                      if (recentlySearch.contains(post.postDetail)) {
                        return ListTile(
                          onTap: () {
                            showResults(context);
                            Navigator.pushReplacementNamed(context, '/detail', arguments: post);
                            _saveRecentlySearch(post.postDetail);
                          },
                          title: Text(post.postDetail),
                          trailing: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              _removeRecentlySearch(post.postDetail);
                            },
                          ),
                        );
                      } else {
                        return Container();
                      }

                    },
                  );

                } else {

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: CircularProgressIndicator()
                      ),
                    ],
                  );
                }
              }
            );

          } else {
            
            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                
                Post post = results[index];

                if (post.postDetail.toLowerCase().contains(query.toLowerCase())) {

                  return ListTile(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/detail', arguments: post);
                      _saveRecentlySearch(post.postDetail);
                    },
                    title: Text(post.postDetail),
                  );

                } else {

                  return Container();
                }

              },
            );
          }

        } else {

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: CircularProgressIndicator()
              ),
            ],
          );
          
        }
      },
    );
  }
  
  void _removeRecentlySearch(String searchText) async {
    RxSharedPreferences prefs = RxSharedPreferences.getInstance();

    List<String> recentlySearch = await prefs.getStringList('recentlySearchList') ?? [];
    recentlySearch.remove(searchText);

    await prefs.setStringList('recentlySearchList', recentlySearch);
  }

  void _saveRecentlySearch(String searchText) async {
    RxSharedPreferences prefs = RxSharedPreferences.getInstance();

    List<String> recentlySearch = await prefs.getStringList('recentlySearchList') ?? [];

    if (!recentlySearch.contains(searchText)) {
      recentlySearch.add(searchText);

      await prefs.setStringList('recentlySearchList', recentlySearch);
    }
  }
  
}