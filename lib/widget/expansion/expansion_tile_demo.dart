import 'package:flutter/material.dart';

class ExpansionTileDemo extends StatelessWidget {
  const ExpansionTileDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Expansion Demo')),
      body: Center(
        child: ExpansionTile(
          backgroundColor: Colors.grey,
          leading: Icon(Icons.ac_unit),
          title: Text('Expansion Tile'),
          initiallyExpanded: false,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('List Tile'),
                Text('Title')
              ],
            )

          ],
        ),
      ),
    );
  }
}
