import 'package:flutter/material.dart';

import 'mock_data.dart';
import 'models.dart';

/// Lightweight app-wide state. No external state-management dependency.
class AppState extends ChangeNotifier {
  static final instance = AppState._();
  AppState._();

  ThemeMode themeMode = ThemeMode.light;
  bool get dark => themeMode == ThemeMode.dark;
  void toggleTheme() {
    themeMode = dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  String userName = 'Andrew Ainsley';
  String userEmail = 'andrew_ainsley@yourdomain.com';
  final Map<String, String> profileDetails = {
    'Username': 'andrew_ainsley',
    'Phone Number': '+1-300-555-0399',
    'Date of Birth': '12/27/1995',
    'Street Address': '',
  };

  final Set<String> wishlist = {'hp7', 'metal', 'wish3', 'free-life', 'hp3'};
  final Set<String> purchased = {
    'got',
    'materials',
    'batman',
    'hp3',
    'hp4',
    'hp5',
    'hp6',
  };
  final Set<String> removedDownloads = {};
  final Set<String> finished = {};
  final List<Notice> notifications = List.of(notices);
  final List<PaymentMethod> payments = List.of(paymentMethods);
  final Map<String, List<Review>> userReviews = {};
  final Map<String, bool> switches = {};
  String language = 'English (US)';

  void updateProfile(String name, String email) {
    userName = name;
    userEmail = email;
    notifyListeners();
  }

  void clearNotifications() {
    notifications.clear();
    notifyListeners();
  }

  void addPayment(PaymentMethod method) {
    payments.add(method);
    notifyListeners();
  }

  void addReview(String bookId, double rating, String text) {
    userReviews
        .putIfAbsent(bookId, () => [])
        .insert(0, Review(userName, Colors.orange, rating, 'Just now', text));
    notifyListeners();
  }

  void selectLanguage(String value) {
    language = value;
    notifyListeners();
  }

  bool inWishlist(String id) => wishlist.contains(id);
  void toggleWishlist(String id) {
    wishlist.contains(id) ? wishlist.remove(id) : wishlist.add(id);
    notifyListeners();
  }

  bool isPurchased(String id) => purchased.contains(id) || bk(id).free;
  void buy(String id) {
    purchased.add(id);
    removedDownloads.remove(id);
    wishlist.remove(id);
    notifyListeners();
  }

  void toggleDownload(String id) {
    removedDownloads.contains(id)
        ? removedDownloads.remove(id)
        : removedDownloads.add(id);
    notifyListeners();
  }

  void toggleFinished(String id) {
    finished.contains(id) ? finished.remove(id) : finished.add(id);
    notifyListeners();
  }

  List<Book> get wishlistBooks =>
      wishlist.where((id) => books.containsKey(id)).map(bk).toList();
  List<Book> get purchasedBooks =>
      purchased.toList().reversed.where(books.containsKey).map(bk).toList();

  // Reader settings
  double readerFontSize = 18;
  String readerFont = 'Urbanist';
  Color? readerBackground;
  TextAlign readerAlignment = TextAlign.start;
  double readerBrightness = 1;

  bool loggedIn = false;
  void logout() {
    loggedIn = false;
    notifyListeners();
  }
}
