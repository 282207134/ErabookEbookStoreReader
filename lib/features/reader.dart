import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../core/widgets.dart';
import '../data/app_state.dart';
import '../data/mock_data.dart';
import '../data/models.dart';

final _state = AppState.instance;

class ReaderScreen extends StatefulWidget {
  final Book book;
  const ReaderScreen(this.book, {super.key});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  final scroll = ScrollController();
  bool bars = false;
  int chapter = 0;
  Color? dayBackground;

  Color get bg =>
      _state.readerBackground ?? (_state.dark ? C.dark1 : Colors.white);
  bool get darkPage =>
      ThemeData.estimateBrightnessForColor(bg) == Brightness.dark;
  Color get fg => darkPage ? C.g200 : C.g800;
  bool get isSampleSeries => widget.book.id == 'hp7';
  List<String> get titles =>
      isSampleSeries ? chapters : ['Preview', 'Chapter 1', 'Chapter 2'];
  String get passage =>
      isSampleSeries && chapter == 0 ? readerText : readerPreview;

  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: bg,
    body: SafeArea(
      child: Column(
        children: [
          if (bars)
            Row(
              children: [
                BackButton(color: fg),
                Expanded(
                  child: Text(
                    titles[chapter],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: ts(22, color: fg, weight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  tooltip: 'Search text',
                  onPressed: search,
                  color: fg,
                  icon: const Icon(Icons.search),
                ),
                IconButton(
                  tooltip: 'Audiobook',
                  color: fg,
                  icon: const Icon(Icons.headphones),
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Audiobook playback is unavailable in this demo.',
                      ),
                    ),
                  ),
                ),
                PopupMenuButton<bool>(
                  tooltip: 'Reader options',
                  icon: Icon(Icons.more_horiz, color: fg),
                  onSelected: (_) => setState(() => bars = false),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: true, child: Text('Hide Controls')),
                  ],
                ),
              ],
            ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => bars = !bars),
              behavior: HitTestBehavior.opaque,
              child: SingleChildScrollView(
                controller: scroll,
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                child: Text(
                  passage.trim(),
                  textAlign: _state.readerAlignment,
                  style: ts(
                    _state.readerFontSize,
                    color: fg.withValues(alpha: _state.readerBrightness),
                    height: 1.4,
                  ).copyWith(fontFamily: _state.readerFont),
                ),
              ),
            ),
          ),
          if (bars) _controls(),
        ],
      ),
    ),
  );

  Widget _controls() => Container(
    decoration: BoxDecoration(
      color: bg,
      border: Border(top: BorderSide(color: darkPage ? C.dark4 : C.g200)),
    ),
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        _button(Icons.menu_book_outlined, 'Chapters', openChapters),
        _button(
          Icons.nightlight_outlined,
          'Night Mode',
          () => setState(() {
            if (darkPage) {
              _state.readerBackground = dayBackground ?? Colors.white;
            } else {
              dayBackground = bg;
              _state.readerBackground = C.dark1;
            }
          }),
        ),
        _button(
          Icons.chat_bubble_outline,
          'Comments',
          () =>
              Navigator.pushNamed(context, '/reviews', arguments: widget.book),
        ),
        _button(Icons.settings_outlined, 'Settings', openSettings),
      ],
    ),
  );

  Widget _button(IconData icon, String label, VoidCallback tap) => Expanded(
    child: InkWell(
      onTap: tap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: fg, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: ts(12, color: fg, weight: FontWeight.w600),
            ),
          ],
        ),
      ),
    ),
  );

  Future<void> openChapters() async {
    final result = await showGeneralDialog<int>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close chapters',
      barrierColor: Colors.black54,
      pageBuilder: (context, _, _) => Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: .72,
          heightFactor: 1,
          child: Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: SafeArea(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: SectionHeader('Chapters'),
                  ),
                  for (var index = 0; index < titles.length; index++)
                    ListTile(
                      selected: index == chapter,
                      selectedColor: C.primary,
                      selectedTileColor: _state.dark ? C.dark2 : C.bgOrange,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                      title: Text(
                        'Chapter ${index + 1}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      subtitle: Text(
                        titles[index],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onTap: () => Navigator.pop(context, index),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      transitionBuilder: (_, animation, _, child) => SlideTransition(
        position: Tween(
          begin: const Offset(-1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
    if (result == null || !mounted) return;
    setState(() => chapter = result);
    if (scroll.hasClients) scroll.jumpTo(0);
  }

  Future<void> search() async {
    String query = '';
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search text'),
        content: TextField(
          autofocus: true,
          onChanged: (value) => query = value,
          onSubmitted: (value) => Navigator.pop(context, value),
          decoration: const InputDecoration(hintText: 'Search this chapter'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, query),
            child: const Text('Search'),
          ),
        ],
      ),
    );
    if (result == null || result.trim().isEmpty || !mounted) return;
    final match = passage.toLowerCase().indexOf(result.trim().toLowerCase());
    if (match < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No matches in this chapter')),
      );
    } else if (scroll.hasClients) {
      scroll.animateTo(
        scroll.position.maxScrollExtent * match / passage.length,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  void openSettings() => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    builder: (context) => StatefulBuilder(
      builder: (context, updateSheet) {
        void change(VoidCallback update) {
          setState(update);
          updateSheet(() {});
        }

        return SafeArea(
          child: FractionallySizedBox(
            heightFactor: .73,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(24, 4, 24, 12),
                    children: [
                      const _SettingLabel('Brightness'),
                      Slider(
                        value: _state.readerBrightness,
                        min: .35,
                        max: 1,
                        onChanged: (value) =>
                            change(() => _state.readerBrightness = value),
                      ),
                      const Divider(height: 24),
                      const _SettingLabel('Background Color'),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 9,
                        runSpacing: 9,
                        children: [
                          for (final color in const [
                            Colors.white,
                            C.dark1,
                            Color(0xff6d4c41),
                            Color(0xff607d8b),
                            Color(0xff445db5),
                            Color(0xff07976f),
                            Color(0xff6238a5),
                            Color(0xfff5ead6),
                          ])
                            Semantics(
                              button: true,
                              selected: color == bg,
                              label:
                                  'Background color ${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}',
                              child: InkWell(
                                onTap: () => change(
                                  () => _state.readerBackground = color,
                                ),
                                borderRadius: BorderRadius.circular(9),
                                child: Container(
                                  width: 68,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(9),
                                    border: Border.all(
                                      color: color == bg ? C.primary : C.g300,
                                    ),
                                  ),
                                  child: color == bg
                                      ? const Icon(
                                          Icons.check,
                                          color: C.primary,
                                          size: 18,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const Divider(height: 32),
                      const _SettingLabel('Font'),
                      Wrap(
                        spacing: 8,
                        children: [
                          for (final (family, label) in const [
                            ('Urbanist', 'Urbanist'),
                            ('Roboto', 'Roboto'),
                            ('serif', 'Serif'),
                            ('sans-serif', 'Sans Serif'),
                            ('monospace', 'Monospace'),
                          ])
                            ChoiceChip(
                              label: Text(label),
                              selected: _state.readerFont == family,
                              selectedColor: C.bgOrange,
                              labelStyle: const TextStyle(color: C.primary),
                              onSelected: (_) =>
                                  change(() => _state.readerFont = family),
                            ),
                        ],
                      ),
                      const Divider(height: 28),
                      _SettingLabel(
                        'Font Size  ${_state.readerFontSize.round()}',
                      ),
                      Slider(
                        value: _state.readerFontSize,
                        min: 12,
                        max: 28,
                        divisions: 8,
                        onChanged: (value) =>
                            change(() => _state.readerFontSize = value),
                      ),
                      const Divider(height: 24),
                      const _SettingLabel('Align Text'),
                      SegmentedButton<TextAlign>(
                        showSelectedIcon: false,
                        segments: const [
                          ButtonSegment(
                            value: TextAlign.start,
                            icon: Icon(Icons.format_align_left),
                            tooltip: 'Align left',
                          ),
                          ButtonSegment(
                            value: TextAlign.center,
                            icon: Icon(Icons.format_align_center),
                            tooltip: 'Align center',
                          ),
                          ButtonSegment(
                            value: TextAlign.end,
                            icon: Icon(Icons.format_align_right),
                            tooltip: 'Align right',
                          ),
                          ButtonSegment(
                            value: TextAlign.justify,
                            icon: Icon(Icons.format_align_justify),
                            tooltip: 'Justify',
                          ),
                        ],
                        selected: {_state.readerAlignment},
                        onSelectionChanged: (value) =>
                            change(() => _state.readerAlignment = value.first),
                      ),
                    ],
                  ),
                ),
                _controls(),
              ],
            ),
          ),
        );
      },
    ),
  );
}

class _SettingLabel extends StatelessWidget {
  final String title;
  const _SettingLabel(this.title);
  @override
  Widget build(BuildContext context) => Text(
    title,
    style: ts(
      16,
      weight: FontWeight.w700,
      color: Theme.of(context).colorScheme.onSurface,
    ),
  );
}
