import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/models.dart';
import 'theme.dart';

final _state = AppState.instance;

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final double height;
  const PrimaryButton(this.text, {super.key, this.onTap, this.height = 58});
  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: C.primary,
        foregroundColor: Colors.white,
        disabledBackgroundColor: C.primaryDark,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        textStyle: ts(16, weight: FontWeight.w700),
      ),
      child: Text(text),
    ),
  );
}

class SoftButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  const SoftButton(this.text, {super.key, this.onTap});
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 58,
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: _state.dark ? C.dark2 : C.bgOrange,
        foregroundColor: C.primary,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        textStyle: ts(16, weight: FontWeight.w700),
      ),
      child: Text(text),
    ),
  );
}

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onArrow;
  const SectionHeader(this.title, {super.key, this.onArrow});
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onArrow,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: ts(
                24,
                weight: FontWeight.w700,
                color: _state.dark ? Colors.white : C.g900,
              ),
            ),
          ),
          if (onArrow != null)
            const Icon(Icons.arrow_forward, color: C.primary, size: 22),
        ],
      ),
    ),
  );
}

Widget cover(Book book, {double w = 180, double? h, double radius = 12}) =>
    ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(
        book.cover,
        width: w,
        height: h ?? w * 1.533,
        fit: BoxFit.cover,
      ),
    );

class RatingStars extends StatelessWidget {
  final double value;
  final double size;
  const RatingStars(this.value, {super.key, this.size = 16});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(5, (i) {
      final d = value - i;
      return Icon(
        d >= 0.75
            ? Icons.star
            : (d >= 0.25 ? Icons.star_half : Icons.star_border),
        size: size,
        color: C.secondary,
      );
    }),
  );
}

class RatingBadge extends StatelessWidget {
  final double rating;
  const RatingBadge(this.rating, {super.key});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Icon(Icons.star, size: 16, color: C.g600),
      const SizedBox(width: 4),
      Text(
        '$rating',
        style: ts(
          14,
          weight: FontWeight.w600,
          color: _state.dark ? C.g400 : C.g700,
        ),
      ),
    ],
  );
}

class BookCard extends StatelessWidget {
  final Book book;
  final double width;
  final String? trailing;
  const BookCard(this.book, {super.key, this.width = 180, this.trailing});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => Navigator.pushNamed(context, '/book', arguments: book),
    child: SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          cover(book, w: width),
          const SizedBox(height: 12),
          Text(
            book.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: ts(
              18,
              weight: FontWeight.w700,
              color: _state.dark ? Colors.white : C.g900,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              RatingBadge(book.rating),
              const SizedBox(width: 12),
              Text(
                trailing ?? book.priceLabel,
                style: ts(
                  14,
                  weight: FontWeight.w600,
                  color: _state.dark ? C.g400 : C.g700,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class BookRow extends StatelessWidget {
  final Book book;
  final Widget? trailing;
  final String? subtitle;
  final bool showGenres;
  final VoidCallback? onOpen;
  const BookRow(
    this.book, {
    super.key,
    this.trailing,
    this.subtitle,
    this.showGenres = false,
    this.onOpen,
  });
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap:
        onOpen ?? () => Navigator.pushNamed(context, '/book', arguments: book),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          cover(book, w: 92, h: 138, radius: 12),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: ts(
                    18,
                    weight: FontWeight.w700,
                    color: _state.dark ? Colors.white : C.g900,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                RatingBadge(book.rating),
                const SizedBox(height: 8),
                Text(
                  subtitle ?? book.priceLabel,
                  style: ts(
                    16,
                    weight: FontWeight.w600,
                    color: _state.dark ? C.g400 : C.g700,
                  ),
                ),
                if (showGenres) ...[
                  const SizedBox(height: 8),
                  GenreTags(book.genres.take(3)),
                ],
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    ),
  );
}

class GenreTags extends StatelessWidget {
  final Iterable<String> labels;
  const GenreTags(this.labels, {super.key});

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 6,
    runSpacing: 6,
    children: [
      for (final label in labels)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: _state.dark ? C.dark4 : C.g100,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            style: ts(
              12,
              weight: FontWeight.w600,
              color: _state.dark ? C.g300 : C.g700,
            ),
          ),
        ),
    ],
  );
}

class BottomActions extends StatelessWidget {
  final Widget child;
  const BottomActions({super.key, required this.child});

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    minimum: const EdgeInsets.fromLTRB(24, 12, 24, 24),
    child: child,
  );
}

Future<void> showSuccessDialog(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String message,
  required String action,
  String? cancel,
  required VoidCallback onAction,
  VoidCallback? onCancel,
}) => showDialog<void>(
  context: context,
  barrierDismissible: false,
  builder: (dialogContext) => Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
    backgroundColor: Theme.of(context).colorScheme.surface,
    insetPadding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 108,
            height: 108,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [C.secondary, C.primary]),
            ),
            child: Icon(icon, color: Colors.white, size: 46),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: ts(24, weight: FontWeight.w700, color: C.primary),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: ts(16, color: _state.dark ? C.g300 : C.g800, height: 1.4),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            action,
            onTap: () {
              Navigator.pop(dialogContext);
              onAction();
            },
          ),
          if (cancel != null) ...[
            const SizedBox(height: 12),
            SoftButton(
              cancel,
              onTap: () {
                Navigator.pop(dialogContext);
                onCancel?.call();
              },
            ),
          ],
        ],
      ),
    ),
  ),
);

class GenreCard extends StatelessWidget {
  final Genre genre;
  final double height;
  const GenreCard(this.genre, {super.key, this.height = 80});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => Navigator.pushNamed(context, '/genre-books', arguments: genre),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (genre.image != null)
              Image.asset(genre.image!, fit: BoxFit.cover)
            else
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [genre.color, genre.color.withValues(alpha: 0.6)],
                  ),
                ),
              ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                  ],
                  stops: const [0.4, 1],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  genre.name,
                  style: ts(16, weight: FontWeight.w700, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class TabNavBar extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  const TabNavBar(this.title, {super.key, this.actions = const []});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 8, 16, 8),
    child: Row(
      children: [
        Image.asset('assets/logo.png', width: 28, height: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: ts(
              24,
              weight: FontWeight.w700,
              color: _state.dark ? Colors.white : C.g900,
            ),
          ),
        ),
        ...actions,
      ],
    ),
  );
}

class BackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;
  final bool center;
  const BackAppBar(
    this.title, {
    super.key,
    this.actions = const [],
    this.center = false,
  });
  @override
  Size get preferredSize => const Size.fromHeight(56);
  @override
  Widget build(BuildContext context) => AppBar(
    title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
    centerTitle: center,
    leading: IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.arrow_back),
    ),
    actions: actions,
  );
}

class UnderlineField extends StatelessWidget {
  final String label;
  final String? value;
  final bool obscure;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  const UnderlineField(
    this.label, {
    super.key,
    this.value,
    this.obscure = false,
    this.suffix,
    this.onChanged,
    this.keyboardType,
  });
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: ts(
          14,
          weight: FontWeight.w700,
          color: _state.dark ? Colors.white : C.g900,
        ),
      ),
      const SizedBox(height: 8),
      TextFormField(
        initialValue: value,
        obscureText: obscure,
        onChanged: onChanged,
        keyboardType: keyboardType,
        style: ts(
          16,
          weight: FontWeight.w600,
          color: _state.dark ? Colors.white : C.g900,
        ),
        decoration: InputDecoration(
          isDense: true,
          suffixIcon: suffix,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: C.primary),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: C.primary, width: 2),
          ),
        ),
      ),
    ],
  );
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  const EmptyState(this.icon, this.title, this.body, {super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              color: C.bgOrange,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 56, color: C.primary),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: ts(
              24,
              weight: FontWeight.w700,
              color: _state.dark ? Colors.white : C.g900,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            body,
            textAlign: TextAlign.center,
            style: ts(16, color: C.g600, height: 1.4),
          ),
        ],
      ),
    ),
  );
}

class HScrollBooks extends StatelessWidget {
  final List<Book> list;
  final String? trailing;
  final double horizontalPadding;
  const HScrollBooks(
    this.list, {
    super.key,
    this.trailing,
    this.horizontalPadding = 24,
  });
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 372,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      itemCount: list.length,
      separatorBuilder: (_, _) => const SizedBox(width: 16),
      itemBuilder: (_, i) => BookCard(list[i], trailing: trailing),
    ),
  );
}
