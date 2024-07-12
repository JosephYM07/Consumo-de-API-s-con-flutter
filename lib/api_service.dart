
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'post.dart';
import 'photo.dart';

class ApiService {
  static const String postsUrl = 'https://jsonplaceholder.typicode.com/posts';
  static const String photosUrl = 'https://jsonplaceholder.typicode.com/photos';

  static Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse(postsUrl));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<Post> posts = body.map((dynamic item) => Post.fromJson(item)).toList();
      return posts;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  static Future<List<Photo>> fetchPhotos() async {
    final response = await http.get(Uri.parse(photosUrl));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<Photo> photos = body.map((dynamic item) => Photo.fromJson(item)).toList();
      return photos;
    } else {
      throw Exception('Failed to load photos');
    }
  }
}
