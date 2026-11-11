import 'dart:convert';
import 'dart:ui' as ui;

import 'package:erabook/app.dart';
import 'package:erabook/data/app_state.dart';
import 'package:erabook/data/mock_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('capture 57 Erabook states in each theme', (tester) async {
    final screenshots = <String, String>{};
    binding.reportData = {'screenshots': screenshots};
    final app = AppState.instance;
    final initialWishlist = {...app.wishlist};
    final initialPurchased = {...app.purchased};
    final initialPayments = [...app.payments];
    final initialNotices = [...app.notifications];

    for (final theme in ThemeMode.values.where(
      (theme) => theme != ThemeMode.system,
    )) {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      app.themeMode = theme;
      app.wishlist
        ..clear()
        ..addAll(initialWishlist);
      app.purchased
        ..clear()
        ..addAll(initialPurchased);
      app.payments
        ..clear()
        ..addAll(initialPayments);
      app.notifications
        ..clear()
        ..addAll(initialNotices);
      app.finished.clear();
      app.removedDownloads.clear();
      app.userReviews.clear();
      app.readerBackground = null;

      final journey = _Journey(tester, theme.name, screenshots);
      await journey.run();
    }
  }, timeout: const Timeout(Duration(minutes: 8)));
}

class _Journey {
  final WidgetTester tester;
  final String theme;
  final boundary = GlobalKey();
  final Map<String, String> screenshots;
  _Journey(this.tester, this.theme, this.screenshots);

  Future<void> run() async {
    tester.testTextInput.register();
    await tester.pumpWidget(
      RepaintBoundary(key: boundary, child: const ErabookApp()),
    );
    await tester.pump(const Duration(milliseconds: 350));
    await capture(1, 'splash', settle: false);
    await tester.pump(const Duration(seconds: 2));
    await capture(2, 'welcome');

    await tap('Get Started');
    await capture(3, 'signup-gender');
    await tap('Continue');
    await capture(4, 'signup-age');
    await tap('Continue');
    await capture(5, 'signup-genre');
    await tap('Continue');
    await capture(6, 'signup-profile');
    await tap('Continue');
    await capture(7, 'signup-account');
    await tap('Sign Up');
    await capture(8, 'signup-success');
    await tap('Get Started');

    await capture(14, 'home');
    await tab('Wishlist');
    await capture(42, 'wishlist');
    await tapTooltip('More options');
    await capture(43, 'wishlist-menu');
    await back();
    await tab('Home');
    await tapTooltip('Notifications');
    await capture(16, 'notifications');
    await tapTooltip('Notification options');
    await tap('Clear All');
    await capture(15, 'notifications-empty');
    await back();
    await tap('Explore by Genre');
    await capture(17, 'genres');
    await tap('Romance');
    await capture(18, 'genre-cards');
    await tapTooltip('List');
    await capture(19, 'genre-list');
    await back();
    await back();

    await tab('Discover');
    await capture(20, 'discover');
    await tapTooltip('Search');
    await tester.enterText(find.byType(TextField).first, 'Harry Potter');
    await capture(21, 'search');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await capture(22, 'search-cards');
    await tapTooltip('List');
    await capture(23, 'search-list');
    await tapTooltip('Filter');
    await capture(24, 'filter');
    await tap('Apply');
    expect(find.text(bk('hp7').title), findsWidgets);
    await tap(bk('hp7').title);

    await capture(26, 'book-detail');
    await tapTooltip('Share');
    await capture(27, 'share');
    await back();
    await tap('About this Ebook');
    await capture(28, 'about-book');
    await back();
    await tap('Ratings & Reviews');
    await capture(29, 'reviews');
    await tapTooltip('Write a review');
    await tapTooltip('Rate 4 stars');
    await tester.enterText(
      find.byType(TextField).first,
      'A memorable ending to the series.',
    );
    await capture(39, 'write-review');
    await tap('Submit');
    await capture(40, 'review-submitted');
    await tap('OK');
    expect(find.text('A memorable ending to the series.'), findsOneWidget);
    await back();

    await tester.drag(find.byType(ListView).first, const Offset(0, -480));
    await capture(25, 'book-detail-scrolled');
    await tester.drag(find.byType(ListView).first, const Offset(0, 1100));
    await tester.pumpAndSettle();

    await tap('Buy USD \$9.99');
    await capture(30, 'payment');
    await tapTooltip('Add payment method');
    await capture(31, 'add-payment');
    await tap('Add');
    await capture(32, 'payment-added');
    await tap('PayPal');
    await capture(33, 'review-summary');
    await tap('Confirm Payment');
    await capture(34, 'purchase-success');
    await tap('Open Ebook');
    await capture(35, 'reader');
    await tester.tapAt(
      tester.getCenter(find.byType(SingleChildScrollView).first),
    );
    await capture(36, 'reader-controls');
    await tap('Chapters');
    await capture(37, 'reader-chapters');
    await back();
    await tap('Settings');
    await capture(38, 'reader-settings');
    await back();
    await back();

    await open('/book', arguments: bk('alpha'));
    await capture(41, 'free-book');
    await back();
    await tab('Purchased');
    expect(AppState.instance.isPurchased('hp7'), isTrue);
    expect(find.text(bk('hp7').title).hitTestable(), findsOneWidget);
    await capture(44, 'purchased');
    await tapTooltip('More options');
    await capture(45, 'purchased-menu');
    await back();
    await tab('Account');
    await capture(46, 'account');
    final dark = AppState.instance.dark;
    await tap('Dark Mode');
    expect(AppState.instance.dark, isNot(dark));
    await tap('Dark Mode');
    expect(AppState.instance.dark, dark);
    await setting('Payment Methods', 47, 'settings-payment');
    await setting('Personal Info', 48, 'settings-personal');
    await setting('Notification', 49, 'settings-notifications');
    await setting('Preferences', 50, 'settings-preferences');
    await setting('Security', 51, 'settings-security');
    await setting('Language', 52, 'settings-language');
    await tap('Help Center');
    await capture(53, 'settings-faq');
    await tester.enterText(find.byType(TextField).first, 'Why');
    await capture(54, 'settings-faq-search');
    await tap('Contact us');
    await capture(55, 'settings-contact');
    await back();
    await setting('About Erabook', 56, 'settings-about');

    final logout = find.text('Logout').first;
    if (logout.evaluate().isEmpty ||
        !logout.hitTestable().evaluate().any((_) => true)) {
      await tester.scrollUntilVisible(
        logout,
        260,
        scrollable: find.byType(Scrollable).first,
      );
    }
    await tap('Logout');
    await capture(57, 'logout');
    await tap('Yes, Logout');

    await tap('I Already Have an Account');
    await capture(9, 'sign-in');
    await tap('Forgot Password');
    await capture(10, 'forgot-password');
    await tap('Continue');
    for (final digit in ['4', '6', '7']) {
      await tap(digit);
    }
    await capture(11, 'otp');
    await tap('2');
    await tap('Confirm');
    await capture(12, 'new-password');
    await tap('Continue');
    await capture(13, 'reset-success');
    await tap('Go to Home');
    await tap('Sign In');
    expect(find.text('Erabook'), findsOneWidget);
    tester.testTextInput.unregister();
  }

  Future<void> setting(String name, int number, String slug) async {
    await tap(name);
    await capture(number, slug);
    await back();
  }

  Future<void> tab(String text) async {
    final navigation = find.byType(BottomNavigationBar).first;
    await action(
      find.descendant(of: navigation, matching: find.text(text)).first,
    );
  }

  NavigatorState get navigator =>
      tester.state<NavigatorState>(find.byType(Navigator).first);

  Future<void> open(String route, {Object? arguments}) async {
    navigator.pushNamed(route, arguments: arguments);
    await tester.pumpAndSettle();
  }

  Future<void> back() async {
    navigator.pop();
    await tester.pumpAndSettle();
  }

  Future<void> tap(String text) => action(find.text(text).first);
  Future<void> tapTooltip(String text) => action(find.byTooltip(text).first);

  Future<void> action(Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  }

  Future<void> capture(int index, String slug, {bool settle = true}) async {
    if (settle) await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final path = '$theme/${index.toString().padLeft(2, '0')}-$slug.png';
    final render =
        boundary.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final frame = await render.toImage(pixelRatio: 1.5);
    try {
      final data = (await frame.toByteData(format: ui.ImageByteFormat.png))!;
      screenshots[path] = base64Encode(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      );
    } finally {
      frame.dispose();
    }
    debugPrint('Captured $theme/$index-$slug');
  }
}
