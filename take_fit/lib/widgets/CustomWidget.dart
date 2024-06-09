import 'package:flutter/material.dart';

class CustomWidget extends StatelessWidget {
  final String text;
  final String imageUrl;
  final VoidCallback? onPressed;

  CustomWidget({required this.text, required this.imageUrl, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white,
              size: 45,
            ),
          ],
        ),
      ),
    );
  }
}
