import 'package:flutter/material.dart';

import 'package:KleanApp/common/constants/colors.dart';
import 'package:KleanApp/common/constants/sizes.dart';

class CustomerAvatar extends StatefulWidget {
  const CustomerAvatar({
    super.key,
    required this.name,
    required this.imageSrc,
    this.onPressed,
  });

  final String name, imageSrc;
  final VoidCallback? onPressed;

  @override
  State<CustomerAvatar> createState() => _CustomerAvatarState();
}

class _CustomerAvatarState extends State<CustomerAvatar> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      onHover: (value) {
        setState(() {
          isHovered = value;
        });
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundImage: NetworkImage(widget.imageSrc),
          ),
          h8,
          Text(
            widget.name,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: isHovered ? AppColors.primary : null),
          )
        ],
      ),
    );
  }
}
