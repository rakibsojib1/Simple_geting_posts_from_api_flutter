import 'package:flutter/material.dart';

import '../Utils/Network_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PostsRepository _postsRepository = PostsRepository();
  final ScrollController _scrollController = ScrollController();
  final List<dynamic> _posts = [];
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchPosts() async {
    if (_isFetching) return;

    setState(() {
      _isFetching = true;
    });

    final fetchedPosts = await _postsRepository.fetchPosts();

    setState(() {
      _posts.addAll(fetchedPosts);
      _isFetching = false;
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Posts',
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          if (index % 2 == 0) {
            // Calculate the page number for the current index
            final pageNumber = (index ~/ 2) + 1;
            return ListTile(
              title: Text('Start of Page $pageNumber'),
              tileColor: Colors.grey[200],
              dense: true,
            );
          }

          final postIndex = (index ~/ 2);
          final post = _posts[postIndex];
          return Column(
            children: [
              ListTile(
                title: Text(post['title']),
                subtitle: Text(post['body']),
              ),
              const Divider(), // Add a divider between posts for better readability
            ],
          );
        },
      ),
    );
  }
}
