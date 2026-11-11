import 'package:flutter/material.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final String cover;
  final double rating;
  final String reviews;
  final double price;
  final String size;
  final int pages;
  final String purchases;
  final List<String> genres;
  final String released;
  final String description;
  final bool free;
  final String language;
  final String age;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.cover,
    this.rating = 4.5,
    this.reviews = '1.2K',
    this.price = 9.99,
    this.size = '5.6 MB',
    this.pages = 320,
    this.purchases = '10M+',
    this.genres = const ['Fiction'],
    this.released = 'Dec, 2015',
    this.description =
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do '
        'eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim '
        'ad minim veniam, quis nostrud exercitation ullamco laboris.',
    this.free = false,
    this.language = 'English',
    this.age = 'Ages 20 & Up',
  });

  String get priceLabel => free ? 'Free' : '\$${price.toStringAsFixed(2)}';
}

class Genre {
  final String name;
  final String? image;
  final Color color;
  const Genre(this.name, {this.image, this.color = const Color(0xFF607D8B)});
}

class Review {
  final String name;
  final Color color;
  final double rating;
  final String date;
  final String text;
  final int likes;
  const Review(
    this.name,
    this.color,
    this.rating,
    this.date,
    this.text, {
    this.likes = 0,
  });
}

class Notice {
  final String title;
  final String body;
  final String time;
  final IconData icon;
  final Color color;
  final bool read;
  const Notice(
    this.title,
    this.body,
    this.time,
    this.icon,
    this.color, {
    this.read = false,
  });
}

class PaymentMethod {
  final String name;
  final String detail;
  final IconData icon;
  final Color color;
  const PaymentMethod(this.name, this.detail, this.icon, this.color);
}
