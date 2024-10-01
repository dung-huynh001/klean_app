import 'package:KleanApp/Utils/token_service.dart';
import 'package:KleanApp/pages/view_profile/user_profile_provider.dart';
import 'package:KleanApp/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:KleanApp/common/constants/colors.dart';
import 'package:KleanApp/common/constants/sizes.dart';
import 'package:KleanApp/common/constants/defaults.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  const Header({super.key, required this.drawerKey});

  final GlobalKey<ScaffoldState> drawerKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppDefaults.padding, vertical: AppDefaults.padding),
      color: AppColors.bgSecondaryLight,
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            if (Responsive.isMobile(context))
              IconButton(
                onPressed: () {
                  drawerKey.currentState!.openDrawer();
                },
                icon: Badge(
                  isLabelVisible: false,
                  child: SvgPicture.asset(
                    "assets/icons/menu_light.svg",
                  ),
                ),
              ),
            if (Responsive.isMobile(context))
              IconButton(
                onPressed: () {},
                icon: Badge(
                  isLabelVisible: false,
                  child: SvgPicture.asset("assets/icons/search_filled.svg"),
                ),
              ),
            if (!Responsive.isMobile(context))
              Expanded(
                flex: 1,
                child: TextFormField(
                  // style: Theme.of(context).textTheme.labelLarge,
                  decoration: InputDecoration(
                    hintText: "Search...",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(
                          left: AppDefaults.padding,
                          right: AppDefaults.padding / 2),
                      child: SvgPicture.asset("assets/icons/search_light.svg"),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    border: AppDefaults.outlineInputBorder,
                    focusedBorder: AppDefaults.focusedOutlineInputBorder,
                  ),
                ),
              ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!Responsive.isMobile(context))
                    IconButton(
                      onPressed: () {},
                      icon: Badge(
                        isLabelVisible: true,
                        child:
                            SvgPicture.asset("assets/icons/message_light.svg"),
                      ),
                    ),
                  if (!Responsive.isMobile(context)) w16,
                  if (!Responsive.isMobile(context))
                    IconButton(
                      onPressed: () {},
                      icon: Badge(
                        isLabelVisible: true,
                        child: SvgPicture.asset(
                            "assets/icons/notification_light.svg"),
                      ),
                    ),
                  if (!Responsive.isMobile(context)) w16,
                  if (!Responsive.isMobile(context))
                    IconButton(
                      onPressed: () {},
                      icon: const CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://cdn.create.vista.com/api/media/small/339818716/stock-photo-doubtful-hispanic-man-looking-with-disbelief-expression"),
                      ),
                    ),
                  UserDropdown(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserDropdown extends StatefulWidget {
  @override
  _UserDropdownState createState() => _UserDropdownState();
}

class _UserDropdownState extends State<UserDropdown> {
  String selectedValue = 'Profile';
  Map<String, dynamic> tokenData = {};

  @override
  void initState() {
    super.initState();
    _getTokenData();
    print(tokenData);
  }

  Future<void> _getTokenData() async {
    String token = await TokenService.getToken() ?? "";
    if (TokenService.isTokenValid(token)) {
      setState(() => tokenData = TokenService.decodingToken(token) ?? {});
      return;
    }
    tokenData = {};
  }

  void _logout(BuildContext context) {
    TokenService.removeToken();
    context.go("/login");
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      underline: SizedBox(),
      icon: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleAvatar(
            child: SvgPicture.asset("assets/icons/person_light.svg"),
            radius: 16,
          ),
          w8,
          Text(
            tokenData.isNotEmpty
                ? tokenData['username']
                : "Failed", // Tên người dùng
            style: const TextStyle(color: Colors.black),
          ),
          const Icon(Icons.arrow_drop_down, color: Colors.white),
        ],
      ),
      items: <String>['Profile', 'Logout']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedValue = newValue!;
        });

        switch (selectedValue) {
          case 'Profile':
            context.push('/profile');
            break;
          case 'Logout':
            _logout(context);
            break;
        }
      },
    );
  }
}
