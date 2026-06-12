import 'dart:io';
import 'package:flutter/material.dart';

class FullImageScreen extends StatelessWidget {

  final dynamic image;

  const FullImageScreen({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      body: Stack(

        children: [

          Center(

            child: InteractiveViewer(

              child:

              image is File

                  ? Image.file(
                image,
                fit: BoxFit.contain,
              )

                  : Image.network(
                image,
                fit: BoxFit.contain,
              ),
            ),
          ),

          Positioned(

            top: 40,
            left: 15,

            child: IconButton(

              onPressed: () {
                Navigator.pop(context);
              },

              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

