import 'package:flutter/material.dart';

import '../data/models.dart';
import '../features/auth.dart';
import '../features/book_detail.dart';
import '../features/browse.dart';
import '../features/onboarding.dart';
import '../features/purchase.dart';
import '../features/reader.dart';
import '../features/review.dart';
import '../features/settings.dart';
import '../features/shell.dart';

Route<dynamic> onGenerateRoute(RouteSettings s) {
  final a = s.arguments;
  Widget page;
  switch (s.name) {
    case '/':
      page = const SplashScreen();
      break;
    case '/welcome':
      page = const WelcomeScreen();
      break;
    case '/signin':
      page = const SignInScreen();
      break;
    case '/signup':
      page = const SignUpScreen();
      break;
    case '/forgot':
      page = const ForgotPasswordScreen();
      break;
    case '/otp':
      page = const OtpScreen();
      break;
    case '/new-password':
      page = const NewPasswordScreen();
      break;
    case '/shell':
      page = const Shell();
      break;
    case '/notifications':
      page = const NotificationsScreen();
      break;
    case '/genres':
      page = const ExploreGenreScreen();
      break;
    case '/genre-books':
      page = GenreBooksScreen(a as Genre);
      break;
    case '/search':
      page = const SearchScreen();
      break;
    case '/search-results':
      page = SearchResultsScreen(a as String);
      break;
    case '/filter':
      return MaterialPageRoute<BookFilter>(
        builder: (_) =>
            FilterScreen(initial: a is BookFilter ? a : const BookFilter()),
        settings: s,
      );
    case '/collection':
      final collection = a as ({String title, List<Book> books});
      page = Scaffold(
        appBar: AppBar(title: Text(collection.title)),
        body: BookResults(collection.books),
      );
      break;
    case '/book':
      page = BookDetailScreen(a as Book);
      break;
    case '/about-book':
      page = AboutBookScreen(a as Book);
      break;
    case '/reviews':
      page = ReviewsScreen(a as Book);
      break;
    case '/write-review':
      final review = a as ({Book book, int rating});
      page = WriteReviewScreen(review.book, initialRating: review.rating);
      break;
    case '/payment':
      page = SelectPaymentScreen(a as Book);
      break;
    case '/add-payment':
      page = const AddPaymentScreen();
      break;
    case '/review-summary':
      final checkout = a as ({Book book, PaymentMethod method});
      page = ReviewSummaryScreen(checkout.book, checkout.method);
      break;
    case '/reader':
      page = ReaderScreen(a as Book);
      break;
    case '/settings-payment':
      page = const SettingsPaymentScreen();
      break;
    case '/settings-personal':
      page = const SettingsPersonalScreen();
      break;
    case '/settings-notification':
      page = const SettingsNotificationScreen();
      break;
    case '/settings-preferences':
      page = const SettingsPreferencesScreen();
      break;
    case '/settings-security':
      page = const SettingsSecurityScreen();
      break;
    case '/settings-language':
      page = const SettingsLanguageScreen();
      break;
    case '/settings-faq':
      page = const SettingsFaqScreen();
      break;
    case '/settings-contact':
      page = const SettingsFaqScreen(initialTab: 1);
      break;
    case '/settings-about':
      page = const SettingsAboutScreen();
      break;
    default:
      page = const SplashScreen();
  }
  return MaterialPageRoute(builder: (_) => page, settings: s);
}
