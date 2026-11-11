import 'package:flutter/material.dart';

import 'models.dart';

const _cv = 'assets/covers/';

final books = <String, Book>{
  'hades': Book(
    id: 'hades',
    title: 'The House of Hades (Heroes of Olympus #4)',
    author: 'Rick Riordan',
    cover: '${_cv}house_of_hades.png',
    rating: 4.6,
    price: 7.50,
    genres: ['Fantasy', 'Adventure'],
  ),
  'blacksmith': Book(
    id: 'blacksmith',
    title: 'My Quiet Blacksmith Life in Another World Vol. 5',
    author: 'Tamamaru',
    cover: '${_cv}quiet_blacksmith.png',
    rating: 4.7,
    price: 6.99,
    genres: ['Fantasy', 'Fiction'],
  ),
  'lotr': Book(
    id: 'lotr',
    title: 'The Lord of the Rings: The Fellowship of the Ring',
    author: 'J.R.R. Tolkien',
    cover: '${_cv}book_carousel3.png',
    rating: 4.8,
    price: 8.99,
    genres: ['Fantasy', 'Adventure'],
  ),
  'dating': Book(
    id: 'dating',
    title:
        'Trapped in a Dating Sim: The World of Otome Games is Tough for Mobs',
    author: 'Yomu Mishima',
    cover: '${_cv}dating_sim.png',
    rating: 4.9,
    price: 8.99,
    genres: ['Romance', 'Comedy'],
  ),
  'starts': Book(
    id: 'starts',
    title: 'It Starts with Us: A Novel',
    author: 'Colleen Hoover',
    cover: '${_cv}it_starts_with_us.png',
    rating: 4.5,
    price: 11.50,
    genres: ['Romance', 'Fiction'],
  ),
  'reco3': Book(
    id: 'reco3',
    title: 'Lord of the Mysteries Vol. 1',
    author: 'Cuttlefish That Loves Diving',
    cover: '${_cv}book_reco3.png',
    rating: 4.7,
    price: 9.99,
    genres: ['Fantasy', 'Mystery'],
  ),
  'batman': Book(
    id: 'batman',
    title: 'Batman: Arkham Unhinged Vol. 1',
    author: 'Derek Fridolfs',
    cover: '${_cv}batman.png',
    rating: 4.3,
    price: 10.44,
    genres: ['Comics', 'Action'],
  ),
  'materials': Book(
    id: 'materials',
    title: 'His Dark Materials: The Golden Compass',
    author: 'Philip Pullman',
    cover: '${_cv}his_dark_materials.png',
    rating: 4.4,
    price: 7.79,
    genres: ['Fantasy', 'Adventure'],
  ),
  'fairy': Book(
    id: 'fairy',
    title: 'Fairy Tale',
    author: 'Stephen King',
    cover: '${_cv}fairy_tale.png',
    rating: 4.7,
    price: 9.99,
    genres: ['Horror', 'Fantasy'],
  ),
  'metal': Book(
    id: 'metal',
    title: 'The Lost Metal: A Mistborn Novel by Brandon Sanderson',
    author: 'Brandon Sanderson',
    cover: '${_cv}lost_metal.png',
    rating: 4.8,
    price: 4.99,
    genres: ['Fantasy', 'Adventure'],
  ),
  'wish3': Book(
    id: 'wish3',
    title: 'The Most Powerful Quotes: 400 Motivational Quotes and Sayings',
    author: 'Benny Lawrence',
    cover: '${_cv}book_wish3.png',
    rating: 4.9,
    price: 2.50,
    genres: ['Inspiration'],
  ),
  'hp7': Book(
    id: 'hp7',
    title: 'Harry Potter and the Deathly Hallows',
    author: 'J.K. Rowling',
    cover: '${_cv}harry_potter_deathly_hallows.png',
    rating: 4.9,
    reviews: '6.8K',
    price: 9.99,
    size: '5.6 MB',
    pages: 784,
    purchases: '50M+',
    released: 'Dec, 2015',
    genres: ['Fantasy', 'Fiction', 'Mystery', 'Magic'],
  ),
  'hp6': Book(
    id: 'hp6',
    title: 'Harry Potter and the Half-Blood Prince',
    author: 'J.K. Rowling',
    cover: '${_cv}harry_potter_half_blood.png',
    rating: 4.8,
    price: 9.99,
    genres: ['Fantasy', 'Magic'],
  ),
  'hp5': Book(
    id: 'hp5',
    title: 'Harry Potter and the Order of the Phoenix',
    author: 'J.K. Rowling',
    cover: '${_cv}harry_potter_phoenix.png',
    rating: 4.9,
    price: 9.99,
    genres: ['Fantasy', 'Magic'],
  ),
  'hp4': Book(
    id: 'hp4',
    title: 'Harry Potter and the Goblet of Fire',
    author: 'J.K. Rowling',
    cover: '${_cv}harry_potter_goblet.png',
    rating: 4.7,
    price: 9.99,
    genres: ['Fantasy', 'Fiction', 'Mystery'],
  ),
  'hp3': Book(
    id: 'hp3',
    title: 'Harry Potter and the Prisoner of Azkaban',
    author: 'J.K. Rowling',
    cover: '${_cv}harry_potter_prisoner.png',
    rating: 4.8,
    price: 4.99,
    genres: ['Fantasy', 'Fiction', 'Mystery'],
  ),
  'free-life': Book(
    id: 'free-life',
    title: 'Free Life Fantasy Online: Immortal Princess Vol. 2',
    author: 'Akimitsu',
    cover: '${_cv}free_life.png',
    rating: 4.7,
    price: 4.99,
    genres: ['Fantasy'],
  ),
  'reign': Book(
    id: 'reign',
    title: 'Reign of Blood',
    author: 'Alexia Purdy',
    cover: '${_cv}reign_of_blood.png',
    rating: 4.9,
    price: 6.99,
    genres: ['Romance', 'Young Adult', 'Comedy'],
  ),
  'marriage': Book(
    id: 'marriage',
    title: 'The Marriage List',
    author: 'Ella Quinn',
    cover: '${_cv}marriage_list.png',
    rating: 4.8,
    price: 10.50,
    genres: ['Romance', 'Fantasy', 'Psychology'],
  ),
  'keeper': Book(
    id: 'keeper',
    title: 'Keeper of Secrets',
    author: 'Julie Thomas',
    cover: '${_cv}keeper_of_secrets.png',
    rating: 4.5,
    price: 11.50,
    genres: ['Romance', 'Comedy', 'Young Adult'],
  ),
  'valentine': Book(
    id: 'valentine',
    title: 'The Valentine’s Hate',
    author: 'Sidney Halston',
    cover: '${_cv}valentines_hate.png',
    rating: 4.4,
    price: 9.99,
    genres: ['Romance', 'Adult', 'Psychology'],
  ),
  'hpPhil': Book(
    id: 'hpPhil',
    title: 'The Ultimate Harry Potter and Philosophy',
    author: 'William Irwin',
    cover: '${_cv}ultimate_harry_potter.png',
    rating: 4.3,
    price: 3.99,
    genres: ['Fantasy', 'Psychology'],
  ),
  'hpSpell': Book(
    id: 'hpSpell',
    title: 'The Harry Potter Spellbook Unofficial Guide',
    author: 'S.G. Eastment',
    cover: '${_cv}harry_potter_spellbook.png',
    rating: 4.1,
    price: 4.50,
    genres: ['Fantasy', 'Magic'],
  ),
  'thorns': Book(
    id: 'thorns',
    title: 'A Court of Thorns & Roses Book 1',
    author: 'Sarah J. Maas',
    cover: '${_cv}court_of_thorns.png',
    rating: 4.6,
    price: 6.50,
    genres: ['Romance', 'Fantasy'],
  ),
  'laughs': Book(
    id: 'laughs',
    title: 'The Batman Who Laughs: Issues 1-7',
    author: 'Scott Snyder',
    cover: '${_cv}batman_who_laughs.png',
    rating: 4.3,
    price: 10.44,
    genres: ['Comics', 'Horror'],
  ),
  'got': Book(
    id: 'got',
    title: 'Game of Thrones: A Song of Ice & Fire',
    author: 'George R.R. Martin',
    cover: '${_cv}game_of_thrones.png',
    rating: 4.4,
    price: 7.79,
    genres: ['Fantasy', 'Action'],
  ),
  'alpha': Book(
    id: 'alpha',
    title: 'Alpha Magic: Reverse Harem Paranormal Wolf Shifters, Alpha Wolf, Witch Romance Standalone',
    author: 'Amelia Shaw',
    size: '2.8 MB',
    pages: 190,
    purchases: '24M+',
    reviews: '2.3K',
    released: 'May, 2016',
    cover: '${_cv}alpha_magic.png',
    rating: 4.4,
    free: true,
    genres: ['Romance', 'Fantasy', 'Action', 'Magic'],
  ),
  'dragon': Book(
    id: 'dragon',
    title: 'Taken by the Dragon King: Dragon Shifters',
    author: 'Amelia Shaw',
    cover: '${_cv}dragon_king.png',
    rating: 4.6,
    free: true,
    genres: ['Romance', 'Fantasy'],
  ),
  'silver': Book(
    id: 'silver',
    title: 'Song of Silver, Flame Like Night',
    author: 'Amelie Wen Zhao',
    cover: '${_cv}song_of_silver.png',
    rating: 4.9,
    price: 10.99,
    genres: ['Fantasy', 'Romance'],
  ),
  'rose': Book(
    id: 'rose',
    title: 'Son of the Poison Rose: A Kagen a Damned Novel',
    author: 'Jonathan Maberry',
    cover: '${_cv}poison_rose.png',
    rating: 4.8,
    price: 8.50,
    genres: ['Fantasy', 'Thriller'],
  ),
};

Book bk(String id) => books[id]!;

final homeFeatured = [bk('hades'), bk('blacksmith'), bk('lotr'), bk('hp7')];
final homeRecommended = [bk('dating'), bk('starts'), bk('reco3'), bk('thorns')];
final homePurchased = [bk('batman'), bk('materials'), bk('got')];

final topCharts = [bk('hp7'), bk('thorns'), bk('silver'), bk('rose')];
final topSelling = [bk('laughs'), bk('got'), bk('lotr'), bk('metal')];
final topFree = [bk('alpha'), bk('dragon')];
final topNew = [bk('silver'), bk('rose'), bk('dating')];

final hpSeries = ['hp7', 'hp6', 'hp5', 'hp4', 'hp3'].map(bk).toList();
final similarBooks = [bk('hpPhil'), bk('hpSpell'), bk('materials')];

final genres = <Genre>[
  const Genre('Romance', image: 'assets/genres/romance.png'),
  const Genre('Thriller', image: 'assets/genres/thriller.png'),
  const Genre('Inspiration', image: 'assets/genres/inspiration.png'),
  const Genre('Fantasy', image: 'assets/genres/fantasy.png'),
  const Genre('Sci-Fi', image: 'assets/genres/sci_fi.png'),
  const Genre('Horror', image: 'assets/genres/horror.png'),
  const Genre('Mystery', image: 'assets/genres/mystery.png'),
  const Genre('Psychology', image: 'assets/genres/psychology.png'),
  const Genre('Comedy', image: 'assets/genres/comedy.png'),
  const Genre('Action', image: 'assets/genres/action.png'),
  const Genre('Adventure', image: 'assets/genres/adventure.png'),
  const Genre('Comics', image: 'assets/genres/comics.png'),
  const Genre("Children's", image: 'assets/genres/children.png'),
  const Genre('Art & Photography', image: 'assets/genres/art.png'),
  const Genre('Food & Drink', image: 'assets/genres/food.png'),
  const Genre('Biography', image: 'assets/genres/biography.png'),
];

final romanceBooks = [
  'reign',
  'marriage',
  'keeper',
  'valentine',
].map(bk).toList();

final reviews = <Review>[
  const Review(
    'Ronald Richards',
    Color(0xFF6949FF),
    5,
    '2 days ago',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. A wonderful read from start to finish!',
    likes: 128,
  ),
  const Review(
    'Savannah Nguyen',
    Color(0xFF019B83),
    4,
    '1 week ago',
    'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Highly recommended.',
    likes: 86,
  ),
  const Review(
    'Cameron Williamson',
    Color(0xFFF89300),
    5,
    '2 weeks ago',
    'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip.',
    likes: 54,
  ),
  const Review(
    'Marvin McKinney',
    Color(0xFF246BFD),
    4,
    '3 weeks ago',
    'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore.',
    likes: 31,
  ),
];

final notices = <Notice>[
  const Notice(
    'Payment Successful',
    'Your purchase of Harry Potter and the Deathly Hallows was successful.',
    'Just now',
    Icons.check_circle,
    Color(0xFF12D18E),
  ),
  const Notice(
    'New Release',
    'Song of Silver, Flame Like Night is now available in the store.',
    '2h ago',
    Icons.auto_stories,
    Color(0xFFF89300),
  ),
  const Notice(
    'Special Offer',
    'Get 30% off on all Romance ebooks this weekend only.',
    '1d ago',
    Icons.local_offer,
    Color(0xFF6949FF),
  ),
  const Notice(
    'Review Approved',
    'Your review for The Lost Metal has been published.',
    '2d ago',
    Icons.rate_review,
    Color(0xFF246BFD),
    read: true,
  ),
];

final paymentMethods = <PaymentMethod>[
  const PaymentMethod(
    'PayPal',
    'Connected',
    Icons.account_balance_wallet,
    Color(0xFF246BFD),
  ),
  const PaymentMethod(
    'Visa',
    '**** **** **** 4831',
    Icons.credit_card,
    Color(0xFF1A1F71),
  ),
  const PaymentMethod(
    'Mastercard',
    '**** **** **** 9276',
    Icons.credit_card,
    Color(0xFFF75555),
  ),
  const PaymentMethod(
    'Google Pay',
    'Connected',
    Icons.g_mobiledata,
    Color(0xFF12D18E),
  ),
];

const readerText = '''
The yew hedges muffled the sound of the men's footsteps. There was a rustle somewhere to their right: Yaxley drew his wand again, pointing it over his companion's head, but the source of the noise proved to be nothing more than a pure-white peacock, strutting majestically along the top of the hedge.

"He always did himself well, Lucius. Peacocks . . ." Yaxley thrust his wand back under his cloak with a snort.

A handsome manor house grew out of the darkness at the end of the straight drive, lights glinting in the diamond-paned downstairs windows. Somewhere in the dark garden beyond the hedge a fountain was playing. Gravel crackled beneath their feet as Snape and Yaxley sped toward the front door, which swung inward at their approach, though nobody had visibly opened it.

The hallway was large, dimly lit, and sumptuously decorated, with a magnificent carpet covering most of the stone floor. The eyes of the pale-faced portraits on the walls followed Snape and Yaxley as they strode past. The two men halted at a heavy wooden door leading into the next room, hesitated for the space of a heartbeat, then Snape turned the bronze handle.

The drawing room was full of silent people, sitting at a long and ornate table. The room's usual furniture had been pushed carelessly against the walls; the occupants were seated in a rough circle around a raised platform at the far end of the room.
''';

final chapters = [
  'Chapter 1 - The Dark Lord Ascending',
  'Chapter 2 - The Seven Potters',
  'Chapter 3 - The Dursleys Departing',
  'Chapter 4 - The Will of Albus Dumbledore',
  'Chapter 5 - Fallen Warrior',
  'Chapter 6 - The Ghoul in Pajamas',
];
const readerPreview =
    'This is a sample chapter. Browse the reading controls to adjust the page, font size, and alignment.';
