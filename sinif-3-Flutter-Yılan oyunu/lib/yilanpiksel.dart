import 'package:flutter/material.dart';

class YilanPiksel extends StatelessWidget {
  const YilanPiksel({Key? key}): super(key:key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(

        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3)
        ),
      ),
    );
  }
}