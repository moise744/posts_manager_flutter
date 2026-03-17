import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  static const String _postsEndpoint = '/posts';

  // GET all posts
  Future<List<Post>> fetchPosts() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl$_postsEndpoint'))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Post.fromJson(json)).toList();
      } else {
        throw HttpException('Failed to load posts. Status: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on HttpException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // GET single post
  Future<Post> fetchPost(int id) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl$_postsEndpoint/$id'))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return Post.fromJson(json.decode(response.body));
      } else {
        throw HttpException('Post not found. Status: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on HttpException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // CREATE post
  Future<Post> createPost({
    required int userId,
    required String title,
    required String body,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl$_postsEndpoint'),
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: json.encode({'userId': userId, 'title': title, 'body': body}),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 201) {
        return Post.fromJson(json.decode(response.body));
      } else {
        throw HttpException('Failed to create post. Status: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on HttpException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // UPDATE post
  Future<Post> updatePost(Post post) async {
    try {
      final response = await http
          .put(
            Uri.parse('$_baseUrl$_postsEndpoint/${post.id}'),
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: json.encode(post.toJson()),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return Post.fromJson(json.decode(response.body));
      } else {
        throw HttpException('Failed to update post. Status: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on HttpException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // DELETE post
  Future<void> deletePost(int id) async {
    try {
      final response = await http
          .delete(Uri.parse('$_baseUrl$_postsEndpoint/$id'))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw HttpException('Failed to delete post. Status: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on HttpException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}