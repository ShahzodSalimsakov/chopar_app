import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String dropdownValue = 'Ваш город';
  var cities = ['Ваш город', 'Ташкент', 'Самарканд', 'Фергана', 'Андижан'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DropdownButton<String>(
          value: dropdownValue,
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
          items:cities.map((String cities) {
            return DropdownMenuItem(value: cities, child: Text(cities));
          }).toList(),
          onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
          });
      },
        ),

      ),
    );
  }
}
