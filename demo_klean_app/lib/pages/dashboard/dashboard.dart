import 'package:KleanApp/pages/dashboard/widgets/comments.dart';
import 'package:KleanApp/pages/dashboard/widgets/get_more_customers.dart';
import 'package:KleanApp/pages/dashboard/widgets/overview.dart';
import 'package:KleanApp/pages/dashboard/widgets/popular_products.dart';
import 'package:KleanApp/pages/dashboard/widgets/pro_tips.dart';
import 'package:KleanApp/pages/dashboard/widgets/product_overview.dart';
import 'package:KleanApp/pages/dashboard/widgets/refund_request.dart';
import 'package:KleanApp/responsive.dart';
import 'package:flutter/material.dart';

import 'package:KleanApp/common/constants/sizes.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!Responsive.isMobile(context)) h4,
        Text(
          "Dashboard",
          style: Theme.of(context)
              .textTheme
              .headlineLarge!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        h4,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  const Overview(),
                  h16,
                  const ProductOverviews(),
                  h16,
                  const ProTips(),
                  h16,
                  const GetMoreCustomers(),
                  if (Responsive.isMobile(context))
                    const Column(
                      children: [
                        h16,
                        PopularProducts(),
                        h16,
                        Comments(),
                        h16,
                        RefundRequest(newRefund: 8, totalRefund: 52),
                        h8,
                      ],
                    ),
                ],
              ),
            ),
            if (!Responsive.isMobile(context)) w16,
            if (!Responsive.isMobile(context))
              const Expanded(
                flex: 2,
                child: Column(
                  children: [
                    PopularProducts(),
                    h16,
                    Comments(),
                    h16,
                    RefundRequest(newRefund: 8, totalRefund: 52),
                    h8,
                  ],
                ),
              ),
          ],
        )
      ],
    );
  }
}
