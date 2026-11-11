import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme.dart';
import '../core/widgets.dart';
import '../data/app_state.dart';
import '../data/mock_data.dart';
import '../data/models.dart';

final _state = AppState.instance;

class BookDetailScreen extends StatefulWidget {
  final Book book;
  const BookDetailScreen(this.book, {super.key});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  int rating = 0;
  Book get book => widget.book;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _state,
    builder: (context, _) {
      final owned = _state.isPurchased(book.id);
      final foreground = Theme.of(context).colorScheme.onSurface;
      return Scaffold(
        appBar: BackAppBar(
          '',
          actions: [
            IconButton(
              tooltip: _state.inWishlist(book.id)
                  ? 'Remove from Wishlist'
                  : 'Add to Wishlist',
              onPressed: () => _state.toggleWishlist(book.id),
              icon: Icon(
                _state.inWishlist(book.id)
                    ? Icons.bookmark
                    : Icons.bookmark_border,
                color: _state.inWishlist(book.id) ? C.primary : foreground,
              ),
            ),
            IconButton(
              tooltip: 'Share',
              onPressed: () => showBookShare(context, book),
              icon: const Icon(Icons.send_outlined),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final width = (constraints.maxWidth * .40).clamp(94.0, 170.0);
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    cover(book, w: width, radius: 10),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.id == 'hp7'
                                ? 'Harry Potter & the Deathly Hallows'
                                : book.title,
                            style: ts(
                              24,
                              weight: FontWeight.w700,
                              color: foreground,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            book.author,
                            style: ts(
                              16,
                              weight: FontWeight.w600,
                              color: C.primary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Released on ${book.released}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 12),
                          GenreTags(book.genres),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            IntrinsicHeight(
              child: Row(
                children: [
                  _Stat('${book.rating} ★', '${book.reviews} reviews'),
                  const VerticalDivider(),
                  _Stat(book.size, 'size'),
                  const VerticalDivider(),
                  _Stat('${book.pages}', 'pages'),
                  const VerticalDivider(),
                  _Stat(book.purchases, book.free ? 'downloaded' : 'purchases'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              owned ? 'Read Ebook' : 'Buy USD ${book.priceLabel}',
              height: 46,
              onTap: () => Navigator.pushNamed(
                context,
                owned ? '/reader' : '/payment',
                arguments: book,
              ),
            ),
            const SizedBox(height: 28),
            SectionHeader(
              'About this Ebook',
              onArrow: () =>
                  Navigator.pushNamed(context, '/about-book', arguments: book),
            ),
            Text(
              book.description,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: ts(18, color: foreground, height: 1.4),
            ),
            const SizedBox(height: 28),
            SectionHeader(
              'Ratings & Reviews',
              onArrow: () =>
                  Navigator.pushNamed(context, '/reviews', arguments: book),
            ),
            RatingOverview(book),
            const Divider(height: 32),
            Center(
              child: Text(
                'Rate this Ebook',
                style: ts(18, color: foreground, weight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 8),
            RatingPicker(rating, (value) => setState(() => rating = value)),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pushNamed(
                  context,
                  '/write-review',
                  arguments: (book: book, rating: rating),
                ),
                child: const Text('Write a Review'),
              ),
            ),
            if (book.author == 'J.K. Rowling')
              _Related(
                'Harry Potter Series',
                hpSeries.where((other) => other.id != book.id).toList(),
              ),
            _Related(
              'Similar Ebooks',
              (book.author == 'J.K. Rowling' ? similarBooks : books.values)
                  .where(
                    (other) =>
                        other.id != book.id &&
                        other.genres.any(book.genres.contains),
                  )
                  .take(5)
                  .toList(),
            ),
          ],
        ),
      );
    },
  );
}

class _Related extends StatelessWidget {
  final String title;
  final List<Book> books;
  const _Related(this.title, this.books);

  @override
  Widget build(BuildContext context) => books.isEmpty
      ? const SizedBox.shrink()
      : Column(
          children: [
            const SizedBox(height: 24),
            SectionHeader(
              title,
              onArrow: () => Navigator.pushNamed(
                context,
                '/collection',
                arguments: (title: title, books: books),
              ),
            ),
            HScrollBooks(books, horizontalPadding: 0),
          ],
        );
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  const _Stat(this.value, this.label);

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    ),
  );
}

class RatingOverview extends StatelessWidget {
  final Book book;
  const RatingOverview(this.book, {super.key});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Column(
        children: [
          Text(
            '${book.rating}',
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w800),
          ),
          RatingStars(book.rating, size: 23),
          const SizedBox(height: 8),
          Text(
            '(${book.reviews} reviews)',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
      const SizedBox(width: 24),
      Expanded(
        child: Column(
          children: [
            for (var index = 0; index < 5; index++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Text(
                      '${5 - index}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: const [.91, .70, .13, .19, .06][index],
                        minHeight: 5,
                        borderRadius: BorderRadius.circular(8),
                        backgroundColor: _state.dark ? C.dark4 : C.g300,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    ],
  );
}

class RatingPicker extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onSelect;
  const RatingPicker(this.rating, this.onSelect, {super.key});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      for (var value = 1; value <= 5; value++)
        IconButton(
          tooltip: 'Rate $value stars',
          onPressed: () => onSelect(value),
          icon: Icon(
            value <= rating ? Icons.star_rounded : Icons.star_border_rounded,
            size: 33,
            color: value <= rating ? C.primary : C.g500,
          ),
        ),
    ],
  );
}

class AboutBookScreen extends StatelessWidget {
  final Book book;
  const AboutBookScreen(this.book, {super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const BackAppBar('About this Ebook'),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          book.description,
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
        const SizedBox(height: 16),
        const Text(
          'Browse the edition information below to find the language, age guidance, and publication details for this ebook.',
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
        const Divider(height: 40),
        for (final (label1, value1, label2, value2) in [
          ('Language', book.language, 'Age', book.age),
          (
            'Author',
            book.author,
            'Publisher',
            book.author == 'J.K. Rowling'
                ? 'Pottermore Publishing'
                : 'Erabook Catalog',
          ),
          (
            'Published on',
            book.released,
            'ISBN',
            book.id == 'hp7' ? '9781781102435' : '—',
          ),
          ('Pages', '${book.pages}', 'Genre', book.genres.join(', ')),
          ('Purchases', book.purchases, 'Size', book.size),
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _field(label1, value1)),
                const SizedBox(width: 16),
                Expanded(child: _field(label2, value2)),
              ],
            ),
          ),
      ],
    ),
  );

  Widget _field(String label, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 6),
      Text(value),
    ],
  );
}

void showBookShare(BuildContext context, Book book) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheet) => BottomActions(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Share',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const Divider(height: 32),
            Wrap(
              spacing: 12,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                for (final (icon, label, color) in const [
                  (Icons.chat_outlined, 'WhatsApp', C.success),
                  (Icons.send_rounded, 'Twitter', C.info),
                  (Icons.facebook, 'Facebook', C.info),
                  (Icons.camera_alt_outlined, 'Instagram', C.red),
                  (Icons.mail_outline, 'Yahoo', C.purple),
                  (Icons.music_note, 'TikTok', C.g900),
                  (Icons.sms_outlined, 'Chat', C.info),
                  (Icons.content_copy, 'Copy Title', C.teal),
                ])
                  InkWell(
                    onTap: () async {
                      await Clipboard.setData(ClipboardData(text: book.title));
                      if (!sheet.mounted || !context.mounted) return;
                      Navigator.pop(sheet);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Ebook title copied')),
                      );
                    },
                    child: SizedBox(
                      width: 76,
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 23,
                            backgroundColor: color,
                            foregroundColor: Colors.white,
                            child: Icon(icon),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class ReviewsScreen extends StatefulWidget {
  final Book book;
  const ReviewsScreen(this.book, {super.key});
  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  int filter = 0;
  final likes = <Review>{};

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    return ListenableBuilder(
      listenable: _state,
      builder: (context, _) => Scaffold(
        appBar: BackAppBar(
          'Ratings & Reviews',
          actions: [
            IconButton(
              tooltip: 'Write a review',
              onPressed: () => Navigator.pushNamed(
                context,
                '/write-review',
                arguments: (book: book, rating: 0),
              ),
              icon: const Icon(Icons.edit_outlined),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            RatingOverview(book),
            const Divider(height: 32),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var rating = 0; rating <= 5; rating++)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(rating == 0 ? 'All' : '★ $rating'),
                        selected: filter == rating,
                        showCheckmark: false,
                        selectedColor: C.primary,
                        onSelected: (_) => setState(() => filter = rating),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            for (final review in [...?_state.userReviews[book.id], ...reviews])
              if (filter == 0 || review.rating.round() == filter) ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: review.color,
                    foregroundColor: Colors.white,
                    child: Text(review.name[0]),
                  ),
                  title: Text(
                    review.name,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  trailing: GenreTags(['★ ${review.rating.round()}']),
                ),
                Text(review.text, style: const TextStyle(height: 1.45)),
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Like review',
                      icon: Icon(
                        likes.contains(review)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 20,
                        color: C.primary,
                      ),
                      onPressed: () => setState(
                        () => likes.contains(review)
                            ? likes.remove(review)
                            : likes.add(review),
                      ),
                    ),
                    Text('${review.likes + (likes.contains(review) ? 1 : 0)}'),
                    const SizedBox(width: 16),
                    Text(review.date),
                  ],
                ),
                const Divider(height: 24),
              ],
          ],
        ),
      ),
    );
  }
}
