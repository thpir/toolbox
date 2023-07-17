import 'package:flutter/material.dart';

class AppTile extends StatelessWidget {
  const AppTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20
      ),
      child: ListTile(
        leading: Image.asset('assets/images/ruler.png', height: 20,),
        title: Text('Ruler'),
        subtitle: Text('A Ruler app to measure anything the size of your phone'),
      ),
    );
  }
}