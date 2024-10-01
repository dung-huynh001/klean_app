import 'package:KleanApp/Utils/token_service.dart';
import 'package:KleanApp/common/constants/config.dart';
import 'package:KleanApp/pages/view_profile/user_profile_provider.dart';
import 'package:KleanApp/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:KleanApp/common/constants/colors.dart';
import 'package:KleanApp/common/constants/sizes.dart';
import 'package:KleanApp/common/constants/defaults.dart';
import 'package:provider/provider.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.drawerKey});

  final GlobalKey<ScaffoldState> drawerKey;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (context, provider, child) => Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDefaults.padding, vertical: AppDefaults.padding),
        color: AppColors.bgSecondaryLight,
        child: SafeArea(
          bottom: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  context.go('/');
                },
                icon: const Badge(
                    isLabelVisible: false, child: Icon(Icons.arrow_back)),
              ),
              const Text("Profile",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
              Tooltip(
                message: !provider.editMode
                    ? "Edit"
                    : "Save",
                child: TextButton(
                  onPressed: () async {
                    provider.initEditorController();
                    provider.editMode
                        ? provider.SaveAll()
                        : provider.enableEditMode();
                  },
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                      fontSize: 18,
                    ),
                    foregroundColor:
                        !provider.editMode
                            ? AppColors.iconGrey
                            : AppColors.success,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(provider.editMode
                          ? 'Save'
                          : 'Edit'),
                      const SizedBox(width: 8),
                      Icon(provider.editMode
                          ? Icons.check
                          : Icons.edit_square),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
