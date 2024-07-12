import 'package:flutter/material.dart';
import 'post.dart';
import 'photo.dart';
import 'api_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Posts and Photos App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PostsScreen(),
    );
  }
}

class PostsScreen extends StatefulWidget {
  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  late Future<List<Post>> futurePosts;
  late Future<List<Photo>> futurePhotos;

  @override
  void initState() {
    super.initState();
    futurePosts = ApiService.fetchPosts();
    futurePhotos = ApiService.fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts and Photos'),
      ),
      body: FutureBuilder<List<Post>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No posts found'));
          } else {
            return FutureBuilder<List<Photo>>(
              future: futurePhotos,
              builder: (context, photoSnapshot) {
                if (photoSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (photoSnapshot.hasError) {
                  return Center(child: Text('Error: ${photoSnapshot.error}'));
                } else if (!photoSnapshot.hasData ||
                    photoSnapshot.data!.isEmpty) {
                  return Center(child: Text('No photos found'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Post post = snapshot.data![index];
                      Photo photo = photoSnapshot.data![index];
                      return ListTile(
                        contentPadding: EdgeInsets.all(8.0),
                        leading: CachedNetworkImage(
                          imageUrl: photo.thumbnailUrl,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        title: Text(post.title),
                        subtitle: Text(post.body),
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
