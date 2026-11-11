import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../core/widgets.dart';
import '../data/app_state.dart';
import '../data/models.dart';

final _state = AppState.instance;

class SelectPaymentScreen extends StatelessWidget {
  final Book book;
  const SelectPaymentScreen(this.book, {super.key});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _state,
    builder: (context, _) => Scaffold(
      appBar: BackAppBar(
        'Select Payment Method',
        actions: [
          IconButton(
            tooltip: 'Add payment method',
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/add-payment'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          CheckoutBook(book),
          const Divider(height: 36),
          for (final method in _state.payments)
            PaymentTile(
              method,
              onTap: () => Navigator.pushNamed(
                context,
                '/review-summary',
                arguments: (book: book, method: method),
              ),
            ),
        ],
      ),
    ),
  );
}

class CheckoutBook extends StatelessWidget {
  final Book book;
  const CheckoutBook(this.book, {super.key});

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      cover(book, w: 112, radius: 12),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              book.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            RatingBadge(book.rating),
            const SizedBox(height: 6),
            Text(book.priceLabel),
            const SizedBox(height: 10),
            GenreTags(book.genres.take(3)),
          ],
        ),
      ),
    ],
  );
}

class PaymentTile extends StatelessWidget {
  final PaymentMethod method;
  final VoidCallback? onTap;
  final Widget? trailing;
  const PaymentTile(this.method, {super.key, this.onTap, this.trailing});

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    minVerticalPadding: 10,
    leading: CircleAvatar(
      radius: 24,
      backgroundColor: method.color,
      foregroundColor: Colors.white,
      child: Icon(method.icon),
    ),
    title: Text(
      method.detail == 'Connected' ? method.name : method.detail,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    ),
    trailing:
        trailing ?? (onTap == null ? null : const Icon(Icons.chevron_right)),
    onTap: onTap,
  );
}

class AddPaymentScreen extends StatefulWidget {
  const AddPaymentScreen({super.key});

  @override
  State<AddPaymentScreen> createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  String number = '0000 0000 0000 7839';
  String holder = 'Andrew Ainsley';
  String expiry = '02/30';

  void add() {
    final digits = number.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 4 || holder.trim().isEmpty || expiry.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete the demo card fields.')),
      );
      return;
    }
    final ending = digits.substring(digits.length - 4);
    _state.addPayment(
      PaymentMethod(
        'Demo Card',
        '•••• •••• •••• $ending',
        Icons.credit_card,
        C.g900,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const BackAppBar('Add New'),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xffFFB834), C.primary, Color(0xffE87E00)],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Credit Card',
                      style: ts(
                        20,
                        color: Colors.white,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Icon(Icons.contactless_outlined, color: Colors.white),
                ],
              ),
              const SizedBox(height: 34),
              Text(
                '••••  ••••  ••••  ••••',
                style: ts(23, color: Colors.white, letterSpacing: 1),
              ),
              const SizedBox(height: 26),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Card Holder Name\nFull Name',
                      style: ts(14, color: Colors.white, height: 1.5),
                    ),
                  ),
                  Text(
                    'Expiry Date\n00/00',
                    style: ts(14, color: Colors.white, height: 1.5),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        UnderlineField(
          'Card Number',
          value: number,
          keyboardType: TextInputType.number,
          onChanged: (value) => number = value,
        ),
        const SizedBox(height: 24),
        UnderlineField(
          'Full Name',
          value: holder,
          onChanged: (value) => holder = value,
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: UnderlineField(
                'Expiry Date',
                value: expiry,
                onChanged: (value) => expiry = value,
              ),
            ),
            const SizedBox(width: 24),
            const Expanded(
              child: UnderlineField(
                'CVV',
                value: '000',
                obscure: true,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    ),
    bottomNavigationBar: BottomActions(child: PrimaryButton('Add', onTap: add)),
  );
}

class ReviewSummaryScreen extends StatelessWidget {
  final Book book;
  final PaymentMethod method;
  const ReviewSummaryScreen(this.book, this.method, {super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const BackAppBar('Review Summary'),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        CheckoutBook(book),
        const SizedBox(height: 24),
        Card(
          elevation: 0,
          color: _state.dark ? C.dark2 : C.g50,
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _line('Price', book.priceLabel),
                _line('Tax', '\$1.00'),
                const Divider(height: 20),
                _line(
                  'Total (USD)',
                  '\$${(book.price + 1).toStringAsFixed(2)}',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        const SectionHeader('Selected Payment Method'),
        PaymentTile(
          method,
          trailing: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Change', style: TextStyle(color: C.primary)),
          ),
        ),
      ],
    ),
    bottomNavigationBar: BottomActions(
      child: PrimaryButton(
        'Confirm Payment',
        onTap: () {
          _state.buy(book.id);
          showSuccessDialog(
            context,
            icon: Icons.shopping_cart_outlined,
            title: 'Successful Purchase!',
            message: 'You have successfully purchased ${book.title}.',
            action: 'Open Ebook',
            cancel: 'Close',
            onAction: () => Navigator.pushNamedAndRemoveUntil(
              context,
              '/reader',
              (route) => route.settings.name == '/shell',
              arguments: book,
            ),
            onCancel: () => Navigator.popUntil(
              context,
              (route) => route.settings.name == '/shell' || route.isFirst,
            ),
          );
        },
      ),
    ),
  );

  Widget _line(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Expanded(child: Text(label)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    ),
  );
}
