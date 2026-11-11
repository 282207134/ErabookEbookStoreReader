import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../core/widgets.dart';
import '../data/app_state.dart';
import 'purchase.dart';

final _state = AppState.instance;

class _Page extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget? footer;
  const _Page(this.title, this.children, {this.footer});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: BackAppBar(title),
    body: ListView(padding: const EdgeInsets.all(24), children: children),
    bottomNavigationBar: footer == null ? null : BottomActions(child: footer!),
  );
}

class _Toggle extends StatefulWidget {
  final String label;
  final bool initial;
  const _Toggle(this.label, this.initial);
  @override
  State<_Toggle> createState() => _ToggleState();
}

class _ToggleState extends State<_Toggle> {
  @override
  Widget build(BuildContext context) => SwitchListTile(
    contentPadding: EdgeInsets.zero,
    value: _state.switches[widget.label] ?? widget.initial,
    title: Text(
      widget.label,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
    onChanged: (value) => setState(() => _state.switches[widget.label] = value),
  );
}

class SettingsPaymentScreen extends StatelessWidget {
  const SettingsPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _state,
    builder: (context, _) => _Page(
      'Payment Methods',
      [
        for (final method in _state.payments)
          PaymentTile(
            method,
            trailing: const Text(
              'Connected',
              style: TextStyle(color: C.primary),
            ),
          ),
      ],
      footer: PrimaryButton(
        '+  Add New',
        onTap: () => Navigator.pushNamed(context, '/add-payment'),
      ),
    ),
  );
}

class SettingsPersonalScreen extends StatefulWidget {
  const SettingsPersonalScreen({super.key});

  @override
  State<SettingsPersonalScreen> createState() => _SettingsPersonalScreenState();
}

class _SettingsPersonalScreenState extends State<SettingsPersonalScreen> {
  late String name = _state.userName;
  late String email = _state.userEmail;
  late final fields = Map<String, String>.of(_state.profileDetails);

  void save() {
    if (name.trim().isEmpty || !email.contains('@')) {
      _notice(context, 'Enter your name and a valid email address.');
      return;
    }
    _state.profileDetails.addAll(fields);
    _state.updateProfile(name.trim(), email.trim());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => _Page('Personal Info', [
    const Center(
      child: CircleAvatar(
        radius: 50,
        backgroundImage: AssetImage('assets/andrew.png'),
      ),
    ),
    const SizedBox(height: 28),
    UnderlineField(
      'Full Name',
      value: name,
      onChanged: (value) => name = value,
    ),
    const SizedBox(height: 24),
    UnderlineField(
      'Email',
      value: email,
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) => email = value,
    ),
    for (final entry in fields.entries) ...[
      const SizedBox(height: 24),
      UnderlineField(
        entry.key,
        value: entry.value,
        onChanged: (value) => fields[entry.key] = value,
      ),
    ],
  ], footer: PrimaryButton('Save Changes', onTap: save));
}

class SettingsNotificationScreen extends StatelessWidget {
  const SettingsNotificationScreen({super.key});
  @override
  Widget build(BuildContext context) => const _Page('Notification', [
    SectionHeader('Notify me when…'),
    _Toggle('There is a New Recommendation', true),
    _Toggle("There's a New Book Series", false),
    _Toggle('There is an update from Authors', false),
    _Toggle('There are Price Drops Available', true),
    _Toggle('When I Make a Purchase', true),
    _Toggle('Enable App System Notifications', true),
    _Toggle('New Tips & Services Available', false),
    _Toggle('Participate in Survey', false),
  ]);
}

class SettingsPreferencesScreen extends StatefulWidget {
  const SettingsPreferencesScreen({super.key});
  @override
  State<SettingsPreferencesScreen> createState() =>
      _SettingsPreferencesScreenState();
}

class _SettingsPreferencesScreenState extends State<SettingsPreferencesScreen> {
  bool cleared = false;
  String quality = 'Standard';

  @override
  Widget build(BuildContext context) => _Page('Preferences', [
    const SectionHeader('General'),
    const _Toggle('Download Over Wi-Fi Only', true),
    ListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text('Clear Cache'),
      trailing: Text(cleared ? '0 MB' : '128 MB'),
      onTap: () => setState(() => cleared = true),
    ),
    const Divider(height: 32),
    const SectionHeader('Reading'),
    const _Toggle('Auto Rotate Screen', true),
    const _Toggle('Use 3D Effect for Page Turning', true),
    const Divider(height: 32),
    const SectionHeader('Audiobook'),
    ListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text('Audio Quality'),
      trailing: DropdownButton<String>(
        value: quality,
        underline: const SizedBox.shrink(),
        items: const [
          DropdownMenuItem(value: 'Standard', child: Text('Standard')),
          DropdownMenuItem(value: 'High', child: Text('High')),
        ],
        onChanged: (value) {
          if (value != null) setState(() => quality = value);
        },
      ),
    ),
    const _Toggle('Automatically Download Audio', false),
  ]);
}

class SettingsSecurityScreen extends StatelessWidget {
  const SettingsSecurityScreen({super.key});
  @override
  Widget build(BuildContext context) => _Page('Security', [
    const _Toggle('Remember me', true),
    const _Toggle('Biometric ID', false),
    const _Toggle('Face ID', false),
    const _Toggle('SMS Authenticator', false),
    const _Toggle('Google Authenticator', false),
    ListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text('Device Management'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _notice(context, 'This demo runs on the current device.'),
    ),
    const SizedBox(height: 24),
    SoftButton(
      'Change Password',
      onTap: () => Navigator.pushNamed(context, '/new-password'),
    ),
  ]);
}

class SettingsLanguageScreen extends StatelessWidget {
  const SettingsLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _state,
    builder: (context, _) => RadioGroup<String>(
      groupValue: _state.language,
      onChanged: (value) {
        if (value != null) _state.selectLanguage(value);
      },
      child: _Page('Language', [
        const SectionHeader('Suggested'),
        for (final language in const ['English (US)', 'English (UK)'])
          _language(language),
        const Divider(height: 32),
        const SectionHeader('Language'),
        for (final language in const [
          'Mandarin',
          'Hindi',
          'Spanish',
          'French',
          'Arabic',
          'Bengali',
          'Russian',
          'Indonesia',
        ])
          _language(language),
      ]),
    ),
  );

  Widget _language(String language) => RadioListTile<String>(
    value: language,
    activeColor: C.primary,
    controlAffinity: ListTileControlAffinity.trailing,
    contentPadding: EdgeInsets.zero,
    title: Text(language),
  );
}

class SettingsFaqScreen extends StatefulWidget {
  final int initialTab;
  const SettingsFaqScreen({super.key, this.initialTab = 0});
  @override
  State<SettingsFaqScreen> createState() => _SettingsFaqScreenState();
}

class _SettingsFaqScreenState extends State<SettingsFaqScreen> {
  String query = '';
  String category = 'General';

  static const faqs = [
    (
      'General',
      'What is Erabook?',
      'Erabook is an ebook store and reader. Explore the catalog, save titles, and read sample pages.',
    ),
    (
      'Ebook',
      'How to purchase an Ebook?',
      'Open the ebook details, tap Buy, choose a payment method and confirm the demo purchase.',
    ),
    (
      'Ebook',
      'How to download an Ebook?',
      'Open Purchased and use the download control beside an ebook.',
    ),
    (
      'Service',
      'How to add a payment method?',
      'Open Payment Methods, then Add New to add a demo card.',
    ),
    (
      'Account',
      'How to close an Erabook account?',
      'Use the Contact us tab to find the support channels.',
    ),
    (
      'Ebook',
      'Why can’t I purchase an ebook?',
      'Check whether the book has already been purchased or is free.',
    ),
    (
      'Ebook',
      'Why can’t I download an ebook?',
      'Open the Purchased tab and check the download icon.',
    ),
    (
      'Service',
      'Why can’t I add a payment method?',
      'Complete all demo card fields.',
    ),
    (
      'Account',
      'Why can’t I close an account on Erabook?',
      'Account closure is handled by support.',
    ),
  ];

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 2,
    initialIndex: widget.initialTab,
    child: Scaffold(
      appBar: const BackAppBar('Help Center'),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: TabBar(
              labelColor: C.primary,
              indicatorColor: C.primary,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(text: 'FAQ'),
                Tab(text: 'Contact us'),
              ],
            ),
          ),
          Expanded(child: TabBarView(children: [_faq(), const _Contact()])),
        ],
      ),
    ),
  );

  Widget _faq() {
    final text = query.trim().toLowerCase();
    final items = faqs.where((item) {
      if (text.isNotEmpty) return item.$2.toLowerCase().contains(text);
      if (category == 'General') return !item.$2.startsWith('Why');
      return item.$1 == category;
    });
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final option in const [
                'General',
                'Account',
                'Service',
                'Ebook',
              ])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(option),
                    selected: category == option,
                    selectedColor: C.primary,
                    showCheckmark: false,
                    onSelected: (_) => setState(() => category = option),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          onChanged: (value) => setState(() => query = value),
          decoration: InputDecoration(
            hintText: 'Search',
            prefixIcon: const Icon(Icons.search, size: 20),
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (items.isEmpty) const Center(child: Text('No matching questions')),
        for (final (_, question, answer) in items)
          ExpansionTile(
            key: ValueKey(question),
            initiallyExpanded: text.isEmpty && question == faqs.first.$2,
            tilePadding: const EdgeInsets.symmetric(horizontal: 14),
            childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            title: Text(
              question,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            children: [
              Align(alignment: Alignment.centerLeft, child: Text(answer)),
            ],
          ),
      ],
    );
  }
}

class _Contact extends StatelessWidget {
  const _Contact();

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(24),
    children: [
      for (final (label, icon) in const [
        ('Customer Service', Icons.support_agent),
        ('WhatsApp', Icons.chat_outlined),
        ('Website', Icons.language),
        ('Facebook', Icons.facebook),
        ('Twitter', Icons.send_outlined),
        ('Instagram', Icons.camera_alt_outlined),
      ])
        Card(
          elevation: 0,
          child: ListTile(
            leading: Icon(icon, color: C.primary),
            title: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            onTap: () => _notice(context, '$label is shown for demonstration.'),
          ),
        ),
    ],
  );
}

class SettingsAboutScreen extends StatelessWidget {
  const SettingsAboutScreen({super.key});

  @override
  Widget build(BuildContext context) => _Page('About Erabook', [
    Center(child: Image.asset('assets/logo.png', width: 112, height: 112)),
    const SizedBox(height: 14),
    const Center(
      child: Text(
        'Erabook v1.0.0',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
      ),
    ),
    const Divider(height: 36),
    for (final label in const [
      'Job Vacancy',
      'Fees',
      'Developer',
      'Partner',
      'Accessibility',
      'Feedback',
      'Rate us',
      'Visit Our Website',
      'Follow us on Social Media',
    ])
      ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _notice(context, '$label is shown for demonstration.'),
      ),
  ]);
}

void _notice(BuildContext context, String text) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
