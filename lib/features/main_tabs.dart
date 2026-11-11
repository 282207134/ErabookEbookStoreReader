import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../core/widgets.dart';
import '../data/app_state.dart';
import '../data/mock_data.dart';
import '../data/models.dart';
import 'book_detail.dart';

final _state = AppState.instance;

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _state,
    builder: (context, _) => _content(context),
  );

  Widget _content(BuildContext context) => SafeArea(
    child: Column(
      children: [
        TabNavBar(
          'Erabook',
          actions: [
            _search(context),
            IconButton(
              tooltip: 'Notifications',
              onPressed: () => Navigator.pushNamed(context, '/notifications'),
              icon: const Icon(Icons.notifications_none),
            ),
          ],
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            children: [
              HScrollBooks(homeFeatured),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: SectionHeader(
                  'Explore by Genre',
                  onArrow: () => Navigator.pushNamed(context, '/genres'),
                ),
              ),
              SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: 3,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (_, i) =>
                      SizedBox(width: 160, child: GenreCard(genres[i])),
                ),
              ),
              BookSection('Recommended For You', homeRecommended),
              BookSection('On Your Purchased', [
                ...{
                  ...homePurchased,
                  ..._state.purchasedBooks,
                }.where((book) => _state.isPurchased(book.id)),
              ], trailing: 'Purchased'),
              BookSection('On Your Wishlist', _state.wishlistBooks),
            ],
          ),
        ),
      ],
    ),
  );
}

class DiscoverTab extends StatelessWidget {
  const DiscoverTab({super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Column(
      children: [
        TabNavBar('Discover', actions: [_search(context)]),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              BookSection('Top Charts', topCharts),
              BookSection('Top Selling', topSelling),
              BookSection('Top Free', topFree),
              BookSection('Top New Releases', topNew),
            ],
          ),
        ),
      ],
    ),
  );
}

IconButton _search(BuildContext context) => IconButton(
  tooltip: 'Search',
  onPressed: () => Navigator.pushNamed(context, '/search'),
  icon: const Icon(Icons.search),
);

class BookSection extends StatelessWidget {
  final String title;
  final List<Book> books;
  final String? trailing;
  const BookSection(this.title, this.books, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: SectionHeader(
            title,
            onArrow: () => Navigator.pushNamed(
              context,
              '/collection',
              arguments: (title: title, books: books),
            ),
          ),
        ),
        HScrollBooks(books, trailing: trailing),
      ],
    );
  }
}

enum _BookAction { remove, share, about, series, finished }

class LibraryTab extends StatefulWidget {
  final bool purchased;
  const LibraryTab({super.key, this.purchased = false});

  @override
  State<LibraryTab> createState() => _LibraryTabState();
}

class _LibraryTabState extends State<LibraryTab> {
  bool alphabetical = false;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _state,
    builder: (context, _) => _content(context),
  );

  Widget _content(BuildContext context) {
    final purchased = widget.purchased;
    final books = purchased ? _state.purchasedBooks : _state.wishlistBooks;
    if (alphabetical) books.sort((a, b) => a.title.compareTo(b.title));
    return SafeArea(
      child: Column(
        children: [
          TabNavBar(
            purchased ? 'Purchased' : 'Wishlist',
            actions: [
              _search(context),
              IconButton(
                tooltip: alphabetical ? 'Default order' : 'Sort by title',
                onPressed: () => setState(() => alphabetical = !alphabetical),
                icon: const Icon(Icons.sort),
              ),
            ],
          ),
          Expanded(
            child: books.isEmpty
                ? EmptyState(
                    purchased
                        ? Icons.shopping_bag_outlined
                        : Icons.bookmark_border,
                    purchased ? 'No Purchased Books' : 'Your Wishlist is Empty',
                    purchased
                        ? 'Books you purchase will appear here.'
                        : 'Books you save will appear here.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: books.length,
                    itemBuilder: (context, i) {
                      final book = books[i];
                      return BookRow(
                        book,
                        subtitle: purchased
                            ? (_state.finished.contains(book.id)
                                  ? 'Finished'
                                  : 'Purchased')
                            : null,
                        onOpen: purchased
                            ? () => Navigator.pushNamed(
                                context,
                                '/reader',
                                arguments: book,
                              )
                            : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (purchased)
                              IconButton(
                                tooltip:
                                    _state.removedDownloads.contains(book.id)
                                    ? 'Download'
                                    : 'Remove Download',
                                onPressed: () => _state.toggleDownload(book.id),
                                icon: Icon(
                                  _state.removedDownloads.contains(book.id)
                                      ? Icons.file_download_outlined
                                      : Icons.download_done,
                                  size: 20,
                                  color: C.primary,
                                ),
                              ),
                            _menu(context, book),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _menu(BuildContext context, Book book) {
    final purchased = widget.purchased;
    return PopupMenuButton<_BookAction>(
      tooltip: 'More options',
      position: PopupMenuPosition.under,
      icon: const Icon(Icons.more_vert, size: 20),
      onSelected: (action) {
        switch (action) {
          case _BookAction.remove:
            purchased
                ? _state.toggleDownload(book.id)
                : _state.toggleWishlist(book.id);
          case _BookAction.finished:
            _state.toggleFinished(book.id);
          case _BookAction.series:
            Navigator.pushNamed(
              context,
              '/collection',
              arguments: (
                title: 'View Series',
                books: books.values
                    .where((item) => item.author == book.author)
                    .toList(),
              ),
            );
          case _BookAction.share:
            showBookShare(context, book);
          case _BookAction.about:
            Navigator.pushNamed(context, '/about-book', arguments: book);
        }
      },
      itemBuilder: (_) => [
        _option(
          _BookAction.remove,
          purchased ? Icons.download_outlined : Icons.bookmark_remove_outlined,
          purchased
              ? (_state.removedDownloads.contains(book.id)
                    ? 'Download'
                    : 'Remove Download')
              : 'Remove from Wishlist',
        ),
        if (purchased) ...[
          _option(
            _BookAction.series,
            Icons.library_books_outlined,
            'View Series',
          ),
          _option(
            _BookAction.finished,
            Icons.check_circle_outline,
            _state.finished.contains(book.id)
                ? 'Mark as Unfinished'
                : 'Mark as Finished',
          ),
        ] else
          _option(_BookAction.share, Icons.share_outlined, 'Share'),
        _option(_BookAction.about, Icons.info_outline, 'About Ebook'),
      ],
    );
  }

  PopupMenuItem<_BookAction> _option(
    _BookAction value,
    IconData icon,
    String title,
  ) => PopupMenuItem(
    value: value,
    child: Row(
      children: [Icon(icon, size: 18), const SizedBox(width: 10), Text(title)],
    ),
  );
}

class AccountTab extends StatelessWidget {
  const AccountTab({super.key});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _state,
    builder: (context, _) => _content(context),
  );

  Widget _content(BuildContext context) => SafeArea(
    child: Column(
      children: [
        const TabNavBar('Account'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage('assets/andrew.png'),
                ),
                title: Text(
                  _state.userName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  _state.userEmail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => Navigator.pushNamed(context, '/settings-personal'),
                trailing: const Icon(Icons.chevron_right),
              ),
              const Divider(height: 24),
              for (final (label, icon, color, route) in _settings)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: _icon(icon, color),
                  title: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  trailing: route == '/settings-language'
                      ? Text(_state.language)
                      : const Icon(Icons.chevron_right),
                  onTap: () => Navigator.pushNamed(context, route),
                ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                secondary: _icon(Icons.dark_mode_outlined, C.info),
                title: const Text(
                  'Dark Mode',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                value: _state.dark,
                onChanged: (_) => _state.toggleTheme(),
              ),
              const Divider(height: 24),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: _icon(Icons.logout, C.error),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: C.error,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () => _logout(context),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  static const _settings = [
    (
      'Payment Methods',
      Icons.account_balance_wallet_outlined,
      C.success,
      '/settings-payment',
    ),
    ('Personal Info', Icons.person_outline, C.info, '/settings-personal'),
    (
      'Notification',
      Icons.notifications_none,
      C.error,
      '/settings-notification',
    ),
    ('Preferences', Icons.settings_outlined, C.purple, '/settings-preferences'),
    ('Security', Icons.verified_user_outlined, C.success, '/settings-security'),
    ('Language', Icons.language, C.primary, '/settings-language'),
    ('Help Center', Icons.help_outline, C.success, '/settings-faq'),
    ('About Erabook', Icons.info_outline, C.primary, '/settings-about'),
  ];

  Widget _icon(IconData icon, Color color) => CircleAvatar(
    radius: 20,
    backgroundColor: color.withValues(alpha: .10),
    foregroundColor: color,
    child: Icon(icon, size: 22),
  );

  Future<void> _logout(BuildContext context) async {
    final confirm = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (sheet) => BottomActions(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Logout',
              style: ts(24, color: C.error, weight: FontWeight.w700),
            ),
            const Divider(height: 36),
            const Text('Are you sure you want to log out?'),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: SoftButton(
                    'Cancel',
                    onTap: () => Navigator.pop(sheet, false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    'Yes, Logout',
                    onTap: () => Navigator.pop(sheet, true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    if (confirm != true || !context.mounted) return;
    _state.logout();
    Navigator.pushNamedAndRemoveUntil(context, '/welcome', (_) => false);
  }
}
