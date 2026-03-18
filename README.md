# Posts Manager

A Flutter app that lets you view, create, edit, and delete posts
using the JSONPlaceholder API.

## API Used
https://jsonplaceholder.typicode.com/posts

## Features
- View all posts
- View post details
- Create a new post
- Edit an existing post
- Delete a post

## Dependencies
- http: ^1.2.0

## How to Run
flutter pub get
flutter run

## Project Structure
lib/
├── main.dart
├── models/post.dart
├── services/api_service.dart
└── screens/
    ├── post_list_screen.dart
    ├── post_detail_screen.dart
    └── post_form_screen.dart
