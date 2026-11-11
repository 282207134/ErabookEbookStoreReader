import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../core/widgets.dart';
import '../data/app_state.dart';
import '../data/mock_data.dart';
import '../data/models.dart';

final _state = AppState.instance;

class ExploreGenreScreen extends StatelessWidget {
  const ExploreGenreScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: BackAppBar(
      'Explore by Genre',
      actions: [
        IconButton(
          tooltip: 'Search',
          onPressed: () => Navigator.pushNamed(context, '/search'),
          icon: const Icon(Icons.search),
        ),
      ],
    ),
    body: GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(24),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 185 / 92,
      children: [for (final genre in genres) GenreCard(genre)],
    ),
  );
}

class GenreBooksScreen extends StatelessWidget {
  final Genre genre;
  const GenreBooksScreen(this.genre, {super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: BackAppBar(
      genre.name,
      actions: [
        IconButton(
          tooltip: 'Search',
          onPressed: () => Navigator.pushNamed(context, '/search'),
          icon: const Icon(Icons.search),
        ),
      ],
    ),
    body: BookResults([
      for (final book in {...romanceBooks, ...books.values})
        if (book.genres.contains(genre.name)) book,
    ]),
  );
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = TextEditingController();
  final recent = [
    'Harry Potter and the Half-Blood Prince',
    'Harry Potter and the Order of the Phoenix',
    'The First Mountain Man: Book 1',
    'The Silent Patient',
    'Alpha Magic: Reverse Harem',
    'Taken by the Dragon King: Dragon Shifters',
    'The Legacy: Semester 1: Academy',
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void search(String input) {
    final query = input.trim();
    if (query.isEmpty) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      recent.remove(query);
      recent.insert(0, query);
    });
    Navigator.pushNamed(context, '/search-results', arguments: query);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          _SearchHeader(
            TextField(
              controller: controller,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onSubmitted: search,
              decoration: _searchDecoration(
                hint: 'Search ebooks, authors, genres',
                action: IconButton(
                  tooltip: 'Clear search',
                  onPressed: controller.clear,
                  icon: const Icon(Icons.close, size: 18),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                const SectionHeader('Previous Search'),
                const Divider(),
                for (final term in recent)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      term,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      tooltip: 'Remove search',
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () => setState(() => recent.remove(term)),
                    ),
                    onTap: () => search(term),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

InputDecoration _searchDecoration({String? hint, Widget? action}) =>
    InputDecoration(
      hintText: hint,
      prefixIcon: const Icon(Icons.search, size: 20),
      suffixIcon: action,
      filled: true,
      fillColor: _state.dark ? C.dark2 : C.g100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: C.primary),
      ),
    );

class _SearchHeader extends StatelessWidget {
  final Widget field;
  const _SearchHeader(this.field);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(12, 12, 24, 20),
    child: Row(
      children: [
        const BackButton(),
        Expanded(child: field),
      ],
    ),
  );
}

class SearchResultsScreen extends StatefulWidget {
  final String query;
  const SearchResultsScreen(this.query, {super.key});
  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  var filter = const BookFilter();

  Future<void> openFilter() async {
    final value = await Navigator.pushNamed<BookFilter>(
      context,
      '/filter',
      arguments: filter,
    );
    if (mounted && value != null) setState(() => filter = value);
  }

  @override
  Widget build(BuildContext context) {
    final query = widget.query.toLowerCase();
    final result = filter.apply(
      books.values.where(
        (book) => [
          book.title,
          book.author,
          ...book.genres,
        ].any((value) => value.toLowerCase().contains(query)),
      ),
    );
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _SearchHeader(
              TextFormField(
                initialValue: widget.query,
                readOnly: true,
                onTap: () => Navigator.pushReplacementNamed(context, '/search'),
                decoration: _searchDecoration(
                  action: IconButton(
                    tooltip: 'Filter',
                    onPressed: openFilter,
                    icon: const Icon(Icons.tune, color: C.primary),
                  ),
                ),
              ),
            ),
            Expanded(child: BookResults(result)),
          ],
        ),
      ),
    );
  }
}

class BookResults extends StatefulWidget {
  final List<Book> books;
  const BookResults(this.books, {super.key});

  @override
  State<BookResults> createState() => _BookResultsState();
}

class _BookResultsState extends State<BookResults> {
  bool grid = true;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Show in',
                style: ts(
                  18,
                  weight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Cards',
              onPressed: () => setState(() => grid = true),
              icon: Icon(
                Icons.grid_view_rounded,
                color: grid ? C.primary : null,
              ),
            ),
            IconButton(
              tooltip: 'List',
              onPressed: () => setState(() => grid = false),
              icon: Icon(
                Icons.view_list_rounded,
                color: grid ? null : C.primary,
              ),
            ),
          ],
        ),
      ),
      Expanded(
        child: widget.books.isEmpty
            ? const EmptyState(
                Icons.search_off,
                'No Ebooks Found',
                'Try another search or clear your filters.',
              )
            : grid
            ? LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 650 ? 3 : 2;
                  final width =
                      (constraints.maxWidth - 48 - 16 * (columns - 1)) /
                      columns;
                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 20,
                      mainAxisExtent: width * 1.533 + 100,
                    ),
                    itemCount: widget.books.length,
                    itemBuilder: (_, index) =>
                        BookCard(widget.books[index], width: width),
                  );
                },
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: widget.books.length,
                itemBuilder: (_, index) =>
                    BookRow(widget.books[index], showGenres: true),
              ),
      ),
    ],
  );
}

class BookFilter {
  final String sort;
  final RangeValues price;
  final double rating;
  final Set<String> genres;
  final String language;
  final String age;
  const BookFilter({
    this.sort = 'Trending',
    this.price = const RangeValues(0, 40),
    this.rating = 0,
    this.genres = const {},
    this.language = 'All',
    this.age = 'All',
  });

  List<Book> apply(Iterable<Book> source) {
    double cost(Book book) => book.free ? 0 : book.price;
    final result = source
        .where(
          (book) =>
              book.rating >= rating &&
              cost(book) >= price.start &&
              cost(book) <= price.end &&
              (genres.isEmpty || book.genres.any(genres.contains)) &&
              (language == 'All' || book.language == language) &&
              (age == 'All' || book.age == age),
        )
        .toList();
    switch (sort) {
      case 'Highest Rating':
        result.sort((a, b) => b.rating.compareTo(a.rating));
      case 'Lowest Rating':
        result.sort((a, b) => a.rating.compareTo(b.rating));
      case 'Highest Price':
        result.sort((a, b) => cost(b).compareTo(cost(a)));
      case 'Lowest Price':
        result.sort((a, b) => cost(a).compareTo(cost(b)));
      case 'New Releases':
        result.sort((a, b) => _releaseDate(b).compareTo(_releaseDate(a)));
    }
    return result;
  }

  int _releaseDate(Book book) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final parts = book.released.split(', ');
    return (int.tryParse(parts.last) ?? 0) * 12 + months.indexOf(parts.first);
  }
}

class FilterScreen extends StatefulWidget {
  final BookFilter initial;
  const FilterScreen({super.key, this.initial = const BookFilter()});
  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late String sort;
  late RangeValues price;
  late double rating;
  late Set<String> selectedGenres;
  late String language;
  late String age;

  @override
  void initState() {
    super.initState();
    load(widget.initial);
  }

  void load(BookFilter filter) {
    sort = filter.sort;
    price = filter.price;
    rating = filter.rating;
    selectedGenres = {...filter.genres};
    language = filter.language;
    age = filter.age;
  }

  Widget options<T>(
    String title,
    List<T> choices,
    T selected,
    ValueChanged<T> select,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SectionHeader(title),
      RadioGroup<T>(
        groupValue: selected,
        onChanged: (value) {
          if (value != null) select(value);
        },
        child: Column(
          children: [
            for (final choice in choices)
              RadioListTile<T>(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.trailing,
                value: choice,
                activeColor: C.primary,
                title: Text(
                  choice == 0
                      ? 'All'
                      : choice is double
                      ? '$choice+'
                      : '$choice',
                ),
              ),
          ],
        ),
      ),
      const Divider(height: 32),
    ],
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const BackAppBar('Filter'),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const GenreTags([
          'Sort',
          'Price',
          'Rating',
          'Genre',
          'Language',
          'Age',
        ]),
        const SizedBox(height: 24),
        options(
          'Sort',
          const [
            'Trending',
            'New Releases',
            'Highest Rating',
            'Lowest Rating',
            'Highest Price',
            'Lowest Price',
          ],
          sort,
          (v) => setState(() => sort = v),
        ),
        const SectionHeader('Price'),
        RangeSlider(
          values: price,
          max: 40,
          divisions: 40,
          activeColor: C.primary,
          labels: RangeLabels(
            '\$${price.start.round()}',
            '\$${price.end.round()}',
          ),
          onChanged: (v) => setState(() => price = v),
        ),
        const Divider(height: 32),
        options(
          'Rating',
          const [0.0, 4.5, 4.0],
          rating,
          (v) => setState(() => rating = v),
        ),
        const SectionHeader('Genre'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final name in ['All', ...genres.map((genre) => genre.name)])
              FilterChip(
                label: Text(name),
                selected: name == 'All'
                    ? selectedGenres.isEmpty
                    : selectedGenres.contains(name),
                selectedColor: C.primary,
                showCheckmark: false,
                onSelected: (value) => setState(() {
                  if (name == 'All') {
                    selectedGenres.clear();
                  } else if (value) {
                    selectedGenres.add(name);
                  } else {
                    selectedGenres.remove(name);
                  }
                }),
              ),
          ],
        ),
        const Divider(height: 32),
        options(
          'Language',
          const ['All', 'English', 'Mandarin', 'Other Languages'],
          language,
          (v) => setState(() => language = v),
        ),
        options(
          'Age',
          const ['All', 'Ages 12 & Under', 'Ages 13 - 20', 'Ages 20 & Up'],
          age,
          (v) => setState(() => age = v),
        ),
      ],
    ),
    bottomNavigationBar: BottomActions(
      child: Row(
        children: [
          Expanded(
            child: SoftButton(
              'Reset',
              onTap: () => setState(() => load(const BookFilter())),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: PrimaryButton(
              'Apply',
              onTap: () => Navigator.pop(
                context,
                BookFilter(
                  sort: sort,
                  price: price,
                  rating: rating,
                  genres: Set.unmodifiable(selectedGenres),
                  language: language,
                  age: age,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _state,
    builder: (context, _) => Scaffold(
      appBar: BackAppBar(
        'Notification',
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Notification options',
            onSelected: (value) {
              if (value == 'settings') {
                Navigator.pushNamed(context, '/settings-notification');
              } else {
                _state.clearNotifications();
              }
            },
            icon: const Icon(Icons.settings_outlined),
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'settings',
                child: Text('Notification Settings'),
              ),
              PopupMenuItem(value: 'clear', child: Text('Clear All')),
            ],
          ),
        ],
      ),
      body: _state.notifications.isEmpty
          ? Center(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(24),
                children: [
                  Image.asset('assets/empty_notifications.png', height: 273),
                  const SizedBox(height: 24),
                  Text(
                    'Empty',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "You don't have any notification at this time",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: _state.notifications.length,
              separatorBuilder: (_, _) => const Divider(height: 32),
              itemBuilder: (_, index) {
                final notice = _state.notifications[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: notice.color.withValues(alpha: .12),
                        foregroundColor: notice.color,
                        child: Icon(notice.icon),
                      ),
                      title: Text(
                        notice.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(notice.time),
                      trailing: notice.read
                          ? null
                          : Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: C.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'New',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                    ),
                    const SizedBox(height: 8),
                    Text(notice.body),
                  ],
                );
              },
            ),
    ),
  );
}
