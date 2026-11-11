import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../core/widgets.dart';
import '../data/app_state.dart';

final _s = AppState.instance;
Color get _txt => _s.dark ? Colors.white : C.g900;

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool remember = true;
  bool hide = true;
  String identity = 'andrew.ainsley@yourdomain.com';
  String password = 'password123';

  void signIn() {
    if (identity.trim().isEmpty || password.length < 6) {
      _showError(
        context,
        'Enter your username or email and at least six password characters.',
      );
      return;
    }
    _s.loggedIn = true;
    if (identity.contains('@')) _s.updateProfile(_s.userName, identity.trim());
    Navigator.pushNamedAndRemoveUntil(context, '/shell', (_) => false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.zero,
                ),
                const SizedBox(height: 24),
                Text(
                  'Hello there 👋',
                  style: ts(32, weight: FontWeight.w800, color: _txt),
                ),
                const SizedBox(height: 16),
                Text(
                  'Please enter your username/email and password to sign in.',
                  style: ts(16, color: _s.dark ? C.g400 : C.g800, height: 1.4),
                ),
                const SizedBox(height: 32),
                UnderlineField(
                  'Username / Email',
                  value: identity,
                  onChanged: (value) => identity = value,
                ),
                const SizedBox(height: 24),
                UnderlineField(
                  'Password',
                  value: password,
                  onChanged: (value) => password = value,
                  obscure: hide,
                  suffix: IconButton(
                    onPressed: () => setState(() => hide = !hide),
                    icon: Icon(
                      hide ? Icons.visibility_off : Icons.visibility,
                      color: C.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: remember,
                      activeColor: C.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (v) => setState(() => remember = v ?? true),
                    ),
                    Text(
                      'Remember me',
                      style: ts(16, weight: FontWeight.w600, color: _txt),
                    ),
                  ],
                ),
                const Divider(height: 32),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/forgot'),
                    child: Text(
                      'Forgot Password',
                      style: ts(16, weight: FontWeight.w700, color: C.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'or continue with',
                        style: ts(16, color: C.g600),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _social('G', C.info),
                    _social('', Colors.black),
                    _social('f', C.info),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: PrimaryButton('Sign In', onTap: signIn),
          ),
        ],
      ),
    ),
  );

  Widget _social(String t, Color c) => OutlinedButton(
    onPressed: signIn,
    style: OutlinedButton.styleFrom(
      side: BorderSide(color: _s.dark ? C.dark4 : C.g300),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      minimumSize: const Size(80, 52),
    ),
    child: t.isEmpty
        ? Icon(Icons.apple, color: c, size: 26)
        : Text(
            t,
            style: TextStyle(
              color: c,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
  );
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  int step = 0;
  int gender = 0;
  int age = 2;
  final Set<int> liked = {1, 5, 7, 9, 11, 13, 15};
  bool hide = true;
  bool remember = true;
  String name = 'Andrew Ainsley';
  String phone = '+1-300-555-0399';
  String birthDate = '12/27/1995';
  String country = 'United States';
  String username = 'andrew_ainsley';
  String email = 'andrew.ainsley@yourdomain.com';
  String password = 'password123';
  String confirmation = 'password123';

  static const ages = [
    '14 - 17',
    '18 - 24',
    '25 - 29',
    '30 - 34',
    '35 - 39',
    '40 - 44',
    '45 - 49',
    '≥ 50',
  ];
  static const likeGenres = [
    'Romance',
    'Fantasy',
    'Sci-Fi',
    'Horror',
    'Mystery',
    'Thriller',
    'Psychology',
    'Inspiration',
    'Comedy',
    'Action',
    'Adventure',
    'Comics',
    "Children's",
    'Art & Photography',
    'Food & Drink',
    'Biography',
    'Science & Technology',
    'Guide / How-to',
    'Travel',
  ];

  void next() {
    if (step < 4) {
      setState(() => step++);
    } else {
      if (name.trim().isEmpty ||
          username.trim().isEmpty ||
          !email.contains('@') ||
          password.length < 6 ||
          password != confirmation) {
        _showError(
          context,
          'Check the account details and matching passwords.',
        );
        return;
      }
      FocusManager.instance.primaryFocus?.unfocus();
      showSuccessDialog(
        context,
        icon: Icons.person_outline,
        title: 'Sign Up Successful!',
        message: 'Your account has been created. Start exploring Erabook.',
        action: 'Get Started',
        onAction: () {
          _s.loggedIn = true;
          _s.updateProfile(name.trim(), email.trim());
          Navigator.pushNamedAndRemoveUntil(context, '/shell', (_) => false);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 24, 8),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => step == 0
                      ? Navigator.pop(context)
                      : setState(() => step--),
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (step + 1) / 5,
                      minHeight: 8,
                      backgroundColor: _s.dark ? C.dark4 : C.g200,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  _title(),
                  style: ts(
                    32,
                    weight: FontWeight.w800,
                    color: _txt,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _subtitle(),
                  style: ts(16, color: _s.dark ? C.g400 : C.g800, height: 1.4),
                ),
                const SizedBox(height: 32),
                _body(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: step == 2
                ? Row(
                    children: [
                      Expanded(child: SoftButton('Skip', onTap: next)),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: PrimaryButton('Continue', onTap: next),
                      ),
                    ],
                  )
                : PrimaryButton(
                    step == 4 ? 'Sign Up' : 'Continue',
                    onTap: next,
                  ),
          ),
        ],
      ),
    ),
  );

  String _title() => [
    'What is your gender? 🚻',
    'Choose Your Age 🎯',
    'Choose the Book Genre You Like ❤️',
    'Complete Your Profile 📋',
    'Create an Account 🔐',
  ][step];
  String _subtitle() => [
    'Select gender for better content.',
    'Select age range for better content.',
    'Select your preferred book genre for better recommendations, or you can skip it.',
    "Don't worry, only you can see your personal data. No one else will be able to see it.",
    'Enter your username, email & password. If you forget it, then you have to do forgot password.',
  ][step];

  Widget _body() {
    switch (step) {
      case 0:
        return RadioGroup<int>(
          groupValue: gender,
          onChanged: (v) => setState(() => gender = v!),
          child: Column(
            children: [
              for (var i = 0; i < 3; i++) ...[
                RadioListTile<int>(
                  value: i,
                  activeColor: C.primary,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    ['I am male', 'I am female', 'Rather not to say'][i],
                    style: ts(16, weight: FontWeight.w600, color: _txt),
                  ),
                ),
                const Divider(),
              ],
            ],
          ),
        );
      case 1:
        return LayoutBuilder(
          builder: (context, constraints) => Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              for (var i = 0; i < ages.length; i++)
                SizedBox(
                  width: (constraints.maxWidth - 16) / 2,
                  child: OutlinedButton(
                    onPressed: () => setState(() => age = i),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: age == i
                          ? C.primary
                          : Colors.transparent,
                      foregroundColor: age == i ? Colors.white : C.primary,
                      side: const BorderSide(color: C.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      minimumSize: const Size(0, 48),
                      textStyle: ts(16, weight: FontWeight.w700),
                    ),
                    child: Text(ages[i]),
                  ),
                ),
            ],
          ),
        );
      case 2:
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (var i = 0; i < likeGenres.length; i++)
              OutlinedButton(
                onPressed: () => setState(
                  () => liked.contains(i) ? liked.remove(i) : liked.add(i),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: liked.contains(i)
                      ? C.primary
                      : Colors.transparent,
                  foregroundColor: liked.contains(i) ? Colors.white : C.primary,
                  side: const BorderSide(color: C.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  textStyle: ts(16, weight: FontWeight.w700),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child: Text(likeGenres[i]),
              ),
          ],
        );
      case 3:
        return Column(
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/andrew.png'),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: C.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            UnderlineField(
              'Full Name',
              value: name,
              onChanged: (value) => name = value,
            ),
            const SizedBox(height: 24),
            UnderlineField(
              'Phone Number',
              value: phone,
              onChanged: (value) => phone = value,
            ),
            const SizedBox(height: 24),
            UnderlineField(
              'Date of Birth',
              value: birthDate,
              onChanged: (value) => birthDate = value,
              suffix: const Icon(Icons.calendar_month, color: C.primary),
            ),
            const SizedBox(height: 24),
            UnderlineField(
              'Country',
              value: country,
              onChanged: (value) => country = value,
              suffix: const Icon(Icons.keyboard_arrow_down, color: C.primary),
            ),
          ],
        );
      default:
        return Column(
          children: [
            UnderlineField(
              'Username',
              value: username,
              onChanged: (value) => username = value,
            ),
            const SizedBox(height: 24),
            UnderlineField(
              'Email',
              value: email,
              onChanged: (value) => email = value,
            ),
            const SizedBox(height: 24),
            UnderlineField(
              'Password',
              value: password,
              obscure: hide,
              onChanged: (value) => password = value,
              suffix: IconButton(
                onPressed: () => setState(() => hide = !hide),
                icon: const Icon(Icons.visibility_off, color: C.primary),
              ),
            ),
            const SizedBox(height: 24),
            UnderlineField(
              'Confirm Password',
              value: confirmation,
              obscure: true,
              onChanged: (value) => confirmation = value,
              suffix: const Icon(Icons.visibility_off, color: C.primary),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: remember,
                  activeColor: C.primary,
                  onChanged: (value) =>
                      setState(() => remember = value ?? false),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Text(
                  'Remember me',
                  style: ts(16, weight: FontWeight.w600, color: _txt),
                ),
              ],
            ),
          ],
        );
    }
  }
}

void _showError(BuildContext context, String text) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

class _RecoveryPage extends StatelessWidget {
  final String title;
  final String description;
  final List<Widget> fields;
  final Widget footer;
  const _RecoveryPage(this.title, this.description, this.fields, this.footer);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const BackAppBar(''),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          title,
          style: ts(32, weight: FontWeight.w800, color: _txt),
        ),
        const SizedBox(height: 16),
        Text(
          description,
          style: ts(16, color: _s.dark ? C.g400 : C.g800, height: 1.4),
        ),
        const SizedBox(height: 32),
        ...fields,
      ],
    ),
    bottomNavigationBar: BottomActions(child: footer),
  );
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String email = 'andrew.ainsley@yourdomain.com';

  @override
  Widget build(BuildContext context) => _RecoveryPage(
    'Forgot Password 🔑',
    'Enter your email address. Continue to the verification step.',
    [
      UnderlineField(
        'Email',
        value: email,
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) => email = value,
      ),
    ],
    PrimaryButton(
      'Continue',
      onTap: () {
        if (!email.contains('@') || !email.split('@').last.contains('.')) {
          _showError(context, 'Enter a valid email address.');
          return;
        }
        FocusManager.instance.primaryFocus?.unfocus();
        Navigator.pushNamed(context, '/otp');
      },
    ),
  );
}

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String code = '';

  @override
  Widget build(BuildContext context) => _RecoveryPage(
    'You’ve Got Mail 📩',
    'For this demo, enter the four digits below to continue.',
    [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var index = 0; index < 4; index++)
            Container(
              alignment: Alignment.center,
              width: 58,
              height: 60,
              decoration: BoxDecoration(
                color: _s.dark ? C.dark2 : C.g50,
                border: Border.all(
                  color: code.length == index ? C.primary : Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                index < code.length ? code[index] : ' ',
                style: ts(25, weight: FontWeight.w700, color: _txt),
              ),
            ),
        ],
      ),
      const SizedBox(height: 20),
      const Center(child: Text('Demo code 4672')),
    ],
    Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PrimaryButton(
          'Confirm',
          onTap: code.length == 4
              ? () {
                  if (code != '4672') {
                    _showError(context, 'Use demo code 4672.');
                    return;
                  }
                  Navigator.pushNamed(context, '/new-password');
                }
              : null,
        ),
        const SizedBox(height: 10),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisExtent: 42,
          children: [
            for (final digit in '123456789 0'.split(''))
              digit == ' '
                  ? const SizedBox.shrink()
                  : TextButton(
                      onPressed: () {
                        if (code.length < 4) setState(() => code += digit);
                      },
                      child: Text(
                        digit,
                        style: ts(24, weight: FontWeight.w700, color: _txt),
                      ),
                    ),
            IconButton(
              tooltip: 'Delete digit',
              onPressed: code.isEmpty
                  ? null
                  : () => setState(
                      () => code = code.substring(0, code.length - 1),
                    ),
              icon: const Icon(Icons.backspace_outlined),
            ),
          ],
        ),
      ],
    ),
  );
}

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});
  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  String password = 'newpassword123';
  String confirmation = 'newpassword123';
  bool obscure = true;
  bool remember = true;

  @override
  Widget build(BuildContext context) => _RecoveryPage(
    'Create New Password 🔐',
    'Enter your new password. If you forget it, you can reset it again.',
    [
      UnderlineField(
        'Password',
        value: password,
        obscure: obscure,
        onChanged: (value) => password = value,
        suffix: IconButton(
          tooltip: 'Show or hide password',
          color: C.primary,
          onPressed: () => setState(() => obscure = !obscure),
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          ),
        ),
      ),
      const SizedBox(height: 24),
      UnderlineField(
        'Confirm Password',
        value: confirmation,
        obscure: obscure,
        onChanged: (value) => confirmation = value,
      ),
      CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('Remember me'),
        controlAffinity: ListTileControlAffinity.leading,
        value: remember,
        onChanged: (value) => setState(() => remember = value ?? false),
      ),
    ],
    PrimaryButton(
      'Continue',
      onTap: () {
        if (password.length < 6 || password != confirmation) {
          _showError(
            context,
            'Enter matching passwords with at least six characters.',
          );
          return;
        }
        FocusManager.instance.primaryFocus?.unfocus();
        showSuccessDialog(
          context,
          icon: Icons.check_rounded,
          title: 'Reset Password Successful!',
          message: 'Your password has been successfully changed for this demo.',
          action: 'Go to Home',
          onAction: () => Navigator.popUntil(
            context,
            (route) => route.settings.name == '/signin' || route.isFirst,
          ),
        );
      },
    ),
  );
}
