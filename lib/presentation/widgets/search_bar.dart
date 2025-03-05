import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final double horizontalPadding;
  final Color backgroundColor;
  final Color iconColor;
  final Function()? onTap;

  const CustomSearchBar({
    Key? key, 
    this.horizontalPadding = 20.0,
    this.backgroundColor = Colors.white,
    this.iconColor = Colors.grey,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: iconColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Search',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}