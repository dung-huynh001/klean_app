import 'package:KleanApp/pages/entry_point.dart';
import 'package:KleanApp/pages/login/login.dart';
import 'package:KleanApp/pages/register/register.dart';
import 'package:KleanApp/pages/view_profile/view_profile.dart';
import 'package:KleanApp/utils/token_service.dart';
import 'package:go_router/go_router.dart';

Future<String?> redirectTo() async {
  String token = await TokenService.getToken() ?? "";
  if (TokenService.isTokenValid(token) == false) {
    return '/login';
  }
  return null;
}

final routerConfig = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const EntryPoint(),
      redirect: (context, state) async => await redirectTo()
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const Login(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const Register(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ViewProfile(),
    ),
  ],
);
