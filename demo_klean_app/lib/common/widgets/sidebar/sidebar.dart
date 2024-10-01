import 'package:KleanApp/common/widgets/tabs/theme_tabs.dart';
import 'package:KleanApp/responsive.dart';
import 'package:KleanApp/common/constants/defaults.dart';
import 'package:KleanApp/common/constants/sizes.dart';
import 'package:KleanApp/common/widgets/sidebar/customer_info.dart';
import 'package:KleanApp/common/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/config.dart';
import 'menu_title.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // width: Responsive.isMobile(context) ? double.infinity : null,
      // width: MediaQuery.of(context).size.width < 1300 ? 260 : null,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (Responsive.isMobile(context))
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDefaults.padding,
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: SvgPicture.asset('assets/icons/close_filled.svg'),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDefaults.padding,
                    vertical: AppDefaults.padding * 1.5,
                  ),
                  child: SvgPicture.asset(AppConfig.logo),
                ),
              ],
            ),
            const Divider(),
            h16,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDefaults.padding,
                ),
                child: ListView(
                  children: [
                    MenuTile(
                      isActive: true,
                      title: "Home",
                      activeIconSrc: "assets/icons/home_filled.svg",
                      inactiveIconSrc: "assets/icons/home_light.svg",
                      onPressed: () {},
                    ),
                    ExpansionTile(
                      leading:
                          SvgPicture.asset("assets/icons/diamond_light.svg"),
                      title: Text(
                        "Products",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                      children: [
                        MenuTile(
                          isSubmenu: true,
                          title: "Dashboard",
                          onPressed: () {},
                        ),
                        MenuTile(
                          isSubmenu: true,
                          title: "Products",
                          count: 16,
                          onPressed: () {},
                        ),
                        MenuTile(
                          isSubmenu: true,
                          title: "Add Product",
                          onPressed: () {},
                        ),
                      ],
                    ),

                    // Customers
                    ExpansionTile(
                      leading: SvgPicture.asset(
                          "assets/icons/profile_circled_light.svg"),
                      title: Text(
                        "Customers",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                      children: [
                        MenuTile(
                          isSubmenu: true,
                          title: "Dashboard",
                          onPressed: () {},
                        ),
                        MenuTile(
                          isSubmenu: true,
                          title: "Products",
                          count: 16,
                          onPressed: () {},
                        ),
                        MenuTile(
                          isSubmenu: true,
                          title: "Add Product",
                          onPressed: () {},
                        ),
                      ],
                    ),
                    MenuTile(
                      title: "Shop",
                      activeIconSrc: "assets/icons/store_light.svg",
                      inactiveIconSrc: "assets/icons/store_filled.svg",
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
