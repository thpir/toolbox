import 'package:flutter/material.dart';

class AppTile extends StatelessWidget {
  const AppTile(
      {required this.name,
      required this.assetpath,
      required this.size,
      super.key});

  final String name;
  final String assetpath;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              assetpath,
              height: size,
              width: size,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          name,
          style: Theme.of(context).textTheme.bodyLarge,
          maxLines: 1,
          overflow:TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
