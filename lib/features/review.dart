import 'package:flutter/material.dart';

import '../core/widgets.dart';
import '../data/app_state.dart';
import '../data/models.dart';
import 'book_detail.dart';
import 'purchase.dart';

class WriteReviewScreen extends StatefulWidget {
  final Book book;
  final int initialRating;
  const WriteReviewScreen(this.book, {super.key, this.initialRating = 0});

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  late int rating = widget.initialRating;
  String review = '';

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const BackAppBar('Write a Review'),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        CheckoutBook(widget.book),
        const Divider(height: 42),
        const Center(
          child: Text(
            'Rate this Ebook',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 12),
        RatingPicker(rating, (value) => setState(() => rating = value)),
        const SizedBox(height: 26),
        const SectionHeader('Describe Your Experience (Optional)'),
        TextField(
          onChanged: (value) => review = value,
          maxLines: 7,
          decoration: InputDecoration(
            hintText: 'Share your thoughts about this ebook...',
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    ),
    bottomNavigationBar: BottomActions(
      child: Row(
        children: [
          Expanded(
            child: SoftButton('Cancel', onTap: () => Navigator.pop(context)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: PrimaryButton(
              'Submit',
              onTap: rating == 0
                  ? null
                  : () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      AppState.instance.addReview(
                        widget.book.id,
                        rating.toDouble(),
                        review.trim(),
                      );
                      showSuccessDialog(
                        context,
                        icon: Icons.chat_bubble_outline,
                        title: 'Submitted Successfully',
                        message:
                            'Thank you for providing a rating and review for the ebook: ${widget.book.title}',
                        action: 'OK',
                        onAction: () => Navigator.pop(context),
                      );
                    },
            ),
          ),
        ],
      ),
    ),
  );
}
