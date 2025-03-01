import 'package:flutter/material.dart';

class AudioInfo extends StatelessWidget {
  final String ebook_name;
  final String ebook_text;
  AudioInfo({Key ? key, required this.ebook_name , required this.ebook_text}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'images/vinyl_record.png',
          width: 250,
        ),
        const SizedBox(height: 30),
         Text(
          '${ebook_name}',
          style: TextStyle(fontSize: 30),
        ),
        const SizedBox(height: 20),
           Text(
          '${ebook_text}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
