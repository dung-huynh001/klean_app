import 'package:KleanApp/common/constants/sizes.dart';
import 'package:KleanApp/responsive.dart';
import 'package:KleanApp/common/constants/config.dart';
import 'package:KleanApp/common/constants/defaults.dart';
import 'package:KleanApp/common/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'widgets/register_benefits.dart';
import 'widgets/register_form.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Row(
          children: [
            if (!Responsive.isMobile(context))
              Expanded(
                flex: Responsive.isTablet(context) ? 2 : 1,
                child: Container(
                  color: AppColors.bgLight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// APP LOGO
                      if (!Responsive.isMobile(context))
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDefaults.padding,
                            vertical: AppDefaults.padding * 1.5,
                          ),
                          child: SvgPicture.asset(AppConfig.logo),
                        ),

                      /// SIGNUP BENEFITS
                      const Expanded(child: SignupBenefits()),
                    ],
                  ),
                ),
              ),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  /// SIGNUP FORM
                  const Expanded(child: SignupForm()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// APP LOGO
                      Responsive.isMobile(context)
                          ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDefaults.padding,
                          vertical: AppDefaults.padding,
                        ),
                        child: SvgPicture.asset(AppConfig.logo),
                      )
                          : const SizedBox(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already a member?',
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
                            onPressed: () => context.go('/Login'),
                            child: const Text('Login'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
