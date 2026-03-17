import 'package:flutter/material.dart';
import '../models/post.dart';
import 'post_form_screen.dart';

class PostDetailScreen extends StatelessWidget {
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post #${post.id}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PostFormScreen(post: post),
                ),
              );
            },
            tooltip: 'Edit Post',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chip(
              avatar: const Icon(Icons.person, size: 16),
              label: Text('User ID: ${post.userId}'),
              backgroundColor: const Color(0xFF1565C0).withOpacity(0.1),
            ),
            const SizedBox(height: 16),
            const Text(
              'TITLE',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'CONTENT',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              post.body,
              style: const TextStyle(fontSize: 16, height: 1.7),
            ),
          ],
        ),
      ),
    );
  }
}