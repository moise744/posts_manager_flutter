import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';

class PostFormScreen extends StatefulWidget {
  final Post? post; // null = create mode, non-null = edit mode

  const PostFormScreen({super.key, this.post});

  @override
  State<PostFormScreen> createState() => _PostFormScreenState();
}

class _PostFormScreenState extends State<PostFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _userIdController = TextEditingController();
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool get _isEditing => widget.post != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _titleController.text = widget.post!.title;
      _bodyController.text = widget.post!.body;
      _userIdController.text = widget.post!.userId.toString();
    } else {
      _userIdController.text = '1';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _userIdController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_isEditing) {
        final updatedPost = widget.post!.copyWith(
          title: _titleController.text.trim(),
          body: _bodyController.text.trim(),
          userId: int.parse(_userIdController.text.trim()),
        );
        await _apiService.updatePost(updatedPost);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Post updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } else {
        await _apiService.createPost(
          userId: int.parse(_userIdController.text.trim()),
          title: _titleController.text.trim(),
          body: _bodyController.text.trim(),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Post created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Post' : 'New Post'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _userIdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'User ID',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a user ID';
                  if (int.tryParse(value) == null) return 'User ID must be a number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  prefixIcon: Icon(Icons.title),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Please enter a title';
                  if (value.trim().length < 3) return 'Title must be at least 3 characters';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  prefixIcon: Icon(Icons.article_outlined),
                  alignLabelWithHint: true,
                ),
                maxLines: 8,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Please enter the post content';
                  if (value.trim().length < 10) return 'Content must be at least 10 characters';
                  return null;
                },
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(_isEditing ? Icons.save : Icons.send),
                  label: Text(
                    _isLoading
                        ? 'Saving...'
                        : _isEditing
                            ? 'Save Changes'
                            : 'Create Post',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}