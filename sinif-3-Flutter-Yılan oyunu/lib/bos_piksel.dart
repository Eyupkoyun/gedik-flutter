import 'package:flutter/material.dart';


class BosPiksel extends StatelessWidget {
  const BosPiksel({Key? key}): super(key:key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(

        decoration: BoxDecoration(
            color: Colors.grey[700],
            borderRadius: BorderRadius.circular(3)
        ),
      ),
    );
  }
}