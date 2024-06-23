import 'package:flutter/material.dart';

// Custom TextField Widget
Widget customTextField({
  required TextEditingController controller,
  required String hintText,
  required String? Function(String?) validator,
  double padding = 100, // Default padding
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: padding),
    width: double.infinity, // Ensures it takes up the full width available
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      validator: validator,
    ),
  );
}

// Custom Action Button Widget
Widget customActionButton({
  required BuildContext context,
  required String text,
  required VoidCallback onPressed,
  Color backgroundColor = const Color.fromARGB(255, 0, 0, 0),
  TextStyle textStyle = const TextStyle(fontSize: 24.0, color: Color.fromARGB(255, 255, 255, 255)),
  double width = 200.0,
  double height = 75.0,
  double borderRadius = 8.0,
}) {
  return SizedBox(
    width: width,
    height: height,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
      ),
      child: Text(
        text,
        style: textStyle,
      ),
    ),
  );
}