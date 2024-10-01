import 'package:KleanApp/common/constants/config.dart';
import 'package:KleanApp/common/constants/defaults.dart';
import 'package:KleanApp/common/constants/sizes.dart';
import 'package:KleanApp/common/constants/colors.dart';
import 'package:KleanApp/common/constants/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:KleanApp/utils/request.dart';
import 'package:KleanApp/utils/token_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;
  bool _isLoading = false;

  void _login() async {
    setState(() {
      _emailError = _emailController.text.isEmpty ? 'Email is required' : null;
      _passwordError =
          _passwordController.text.isEmpty ? 'Password is required' : null;
    });

    if (_emailError == null && _passwordError == null) {
      setState(() {
        _isLoading = true;
      });
      try {
        final request = Request();
        final response = await request.post(
          'api/Auth/Login',
          {
            'username': _emailController.text,
            'password': _passwordController.text,
          },
          null,
        );

        if (response != null && response['token'] != null) {
          TokenService.saveToken(response['token']);
          context.go('/');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login failed! Please try again')),
          );
          setState(() {
            _isLoading = false;
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errors occurred: $e')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? AppDefaults.loadingAnimationScreen()
        : Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Center(
                    child: SizedBox(
                      width: 296,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppDefaults.padding * 1.5,
                            ),
                            child: SvgPicture.asset(AppConfig.logo),
                          ),
                          Text(
                            'Login',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          h24,
                          Text(
                            'Sign in with your account',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          h24,
                          const Divider(),
                          h16,

                          /// EMAIL TEXT FIELD
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: "Username",
                              prefixIcon: const Icon(Icons.person),
                              hintText: 'Enter username',
                              errorText: _emailError,
                            ),
                          ),
                          h16,

                          /// PASSWORD TEXT FIELD
                          TextFormField(
                            controller: _passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: const Icon(Icons.lock),
                              hintText: 'Enter password',
                              errorText: _passwordError,
                            ),
                          ),
                          h16,

                          /// SIGN IN BUTTON
                          SizedBox(
                            width: 296,
                            child: ElevatedButton(
                              onPressed: _login,
                              child: const Text('Sign in'),
                            ),
                          ),
                          h24,

                          /// SIGNUP TEXT
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don’t have an account?',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: AppColors.textGrey),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: const TextStyle(
                                    color: AppColors.titleLight,
                                  ),
                                ),
                                onPressed: () => context.go('/register'),
                                child: const Text('Sign up'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
