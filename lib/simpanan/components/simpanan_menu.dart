import 'package:flutter/material.dart';

class SimpananMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              // Aksi menu 1
            },
            child: Text('Menu 1'),
          ),
          ElevatedButton(
            onPressed: () {
              // Aksi menu 2
            },
            child: Text('Menu 2'),
          ),
          ElevatedButton(
            onPressed: () {
              // Aksi menu 3
            },
            child: Text('Menu 3'),
          ),
        ],
      ),
    );
  }
}
