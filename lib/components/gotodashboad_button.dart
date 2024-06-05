import 'package:flutter/material.dart';

class GotodashboadButton extends StatelessWidget {
  final Function()? onTap;

  const GotodashboadButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 369,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(25, 29, 33, 1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Center(
          child: Text(
            "Đi Đến Trang Chủ",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
