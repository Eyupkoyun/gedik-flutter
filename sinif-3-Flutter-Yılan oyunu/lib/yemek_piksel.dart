import 'package:flutter/material.dart';

class YemekPiksel extends StatelessWidget {
  const YemekPiksel({Key? key}): super(key:key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(

        decoration: BoxDecoration(
            color: Colors.lightGreen,
            borderRadius: BorderRadius.circular(3)
        ),
      ),
    );
  }
}