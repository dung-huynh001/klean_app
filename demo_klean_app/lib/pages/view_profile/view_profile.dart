import 'package:KleanApp/common/constants/defaults.dart';
import 'package:KleanApp/common/constants/sizes.dart';
import 'package:KleanApp/pages/dashboard/dashboard.dart';
import 'package:KleanApp/pages/view_profile/user_profile_provider.dart';
import 'package:KleanApp/pages/view_profile/widgets/profile_header.dart';
import 'package:KleanApp/pages/view_profile/widgets/user_profile_form.dart';
import 'package:KleanApp/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

class ViewProfile extends StatelessWidget {
  const ViewProfile({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      body: ChangeNotifierProvider(
        create: (context) => UserProfileProvider(),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  ProfileHeader(drawerKey: _drawerKey),
                  Expanded(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1360),
                      child: ListView(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDefaults.padding *
                                  (Responsive.isMobile(context) ? 1 : 1.5),
                            ),
                            child: SafeArea(child: ProfileScreen()),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
