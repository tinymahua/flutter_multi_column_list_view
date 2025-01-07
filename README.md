<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# Multi Column List View

List view with multi column scalable, customizable, draggable splitter inspired by multi_split_view.

![demo](https://github.com/tinymahua/flutter_multi_column_list_view/blob/main/doc/images/demo.png)

## Features
* Easy to use, display your tables anywhere.
* Fixed header with custom header title.
* Scalable column width by drag adjustment.
* Fast and fully event response for row, just like tap, double tap, hover.
* In a row cell, by distinguishing the content area from the blank area, different events can be triggered by right-clicking.
* Blank rows also support right-click context menu, when list content dose not fill all available space.
* When a row was selected, space in this row will trigger row lever context right-clicking menu.

## Getting Started

Add this to your package's pubspec.yaml file:
```yaml
  dependencies:
    multi_column_list_view: {current_version}
```

Import the library in your file:
```dart
import 'package:multi_column_list_view/multi_column_list_view.dart';
```

Use the multi_column_list_view like this:
```dart
import 'package:flutter/material.dart';
import 'package:multi_column_list_view/multi_column_list_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi Column List View Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Multi Column List View Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<double> _columnWidths = [100, 200, 100, 100];
  final MultiColumnListController _controller = MultiColumnListController();
  String _msg = "";

  @override
  void initState() {
    super.initState();

    loadUsers();
  }

  loadUsers() {
    for (var row in users) {
      _controller.rows.value.add(UserInfo.fromJson(row));
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> columnTitles = [
      const Text("ID"),
      const Text("Name"),
      const Text("Gender"),
      const Text("Address"),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: MultiColumnListView(
                  hoveredRowColor: Colors.blue,
                  tappedRowColor: Colors.grey,
                  controller: _controller,
                  columnWidths: _columnWidths,
                  columnTitles: columnTitles,
                  onRowTap: (int rowIdx){
                    showSnakeBarMsg("Tapped row #${rowIdx+1}.");
                  },
                  onRowDoubleTap: (int rowIdx){
                    showSnakeBarMsg("Double tapped row #${rowIdx+1}.");
                  },
                  onRowContextMenu: (TapDownDetails details, int rowIdx){
                    showSnakeBarMsg("You can custom row context menu for row #${rowIdx+1}.");
                  },
                  onListContextMenu: (TapDownDetails details){
                    showSnakeBarMsg("You can custom list context menu for blank area in row cells.");
                  },
                  rowCellsBuilder: (BuildContext context, int rowIdx) {
                    UserInfo user = _controller.rows.value[rowIdx] as UserInfo;
                    return [
                      Text("${user.id}"),
                      Text("${user.name} ${user.lastName}"),
                      Text(user.gender),
                      Text(user.address,),
                    ];
                  }),
            ),
            Container(
              color: Theme.of(context).appBarTheme.backgroundColor,
              child: Center(child: Text(_msg),),),
          ],
        ),
      ),
    );
  }

  showSnakeBarMsg(String msg){
    setState(() {
      _msg = msg;
    });
  }
}

class UserInfo {
  int id;
  String name;
  String lastName;
  String gender;
  String address;

  UserInfo(this.id, this.name, this.lastName, this.gender, this.address);

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      json['id'],
      json['name'],
      json['last_name'],
      json['gender'],
      json['address'],
    );
  }
}

List<Map<String, dynamic>> users = [
  {
    "id": 1,
    "name": "Bryant",
    "last_name": "Blazic",
    "gender": "Male",
    "address": "4772 Tennessee Parkway"
  },
  {
    "id": 2,
    "name": "Sharron",
    "last_name": "Hamments",
    "gender": "Female",
    "address": "0067 6th Court"
  },
  {
    "id": 3,
    "name": "Neville",
    "last_name": "Babin",
    "gender": "Male",
    "address": "44 Brown Court"
  },
  {
    "id": 4,
    "name": "Shelton",
    "last_name": "Negus",
    "gender": "Male",
    "address": "059 Mccormick Road"
  },
  {
    "id": 5,
    "name": "Diann",
    "last_name": "MacAnulty",
    "gender": "Female",
    "address": "89 Shelley Point"
  },
  {
    "id": 6,
    "name": "Craggie",
    "last_name": "Sket",
    "gender": "Male",
    "address": "86 Almo Point"
  },
  {
    "id": 7,
    "name": "Farrel",
    "last_name": "Screwton",
    "gender": "Male",
    "address": "23745 Sycamore Pass"
  },
  {
    "id": 8,
    "name": "Raphael",
    "last_name": "Alejandre",
    "gender": "Male",
    "address": "432 5th Road"
  },
  {
    "id": 9,
    "name": "Buffy",
    "last_name": "Marrian",
    "gender": "Female",
    "address": "6098 Stang Hill"
  },
  {
    "id": 10,
    "name": "Brunhilda",
    "last_name": "Habden",
    "gender": "Female",
    "address": "205 Tomscot Point"
  },
  {
    "id": 11,
    "name": "Isidore",
    "last_name": "Guerin",
    "gender": "Male",
    "address": "19382 Cottonwood Plaza"
  }
];

```

