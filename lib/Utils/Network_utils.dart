import 'dart:convert';
import 'package:http/http.dart' as http;
class PostsRepository {
  Future<List<dynamic>> fetchPosts() async {
    final url =
        'https://jsonplaceholder.typicode.com/posts?_page=1&_limit=10';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> fetchedPosts = json.decode(response.body);

      return fetchedPosts;
    } else {
      throw Exception('Failed to fetch posts');
    }
  }
}