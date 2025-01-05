import 'package:flutter/material.dart';
import 'package:multi_column_list_view/multi_column_list_view.dart';

void main() {
  runApp(const MyApp());
}

/// The main application widget.
class MyApp extends StatelessWidget {
  /// Creates a new instance of [MyApp].
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

/// The main application widget.
class MyHomePage extends StatefulWidget {

  /// Creates a new instance of [MyHomePage].
  const MyHomePage({super.key, required this.title});

  /// The title of the application.
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
    for (var row in users.sublist(0, 10)) {
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
                  onRowTap: (int rowIdx) {
                    showSnakeBarMsg("Tapped row #${rowIdx + 1}.");
                  },
                  onRowDoubleTap: (int rowIdx) {
                    showSnakeBarMsg("Double tapped row #${rowIdx + 1}.");
                  },
                  onRowContextMenu: (TapDownDetails details, int rowIdx) {
                    showSnakeBarMsg(
                        "You can custom row context menu for row #${rowIdx + 1}.");
                  },
                  onListContextMenu: (TapDownDetails details) {
                    showSnakeBarMsg(
                        "You can custom list context menu for blank area in row cells.");
                  },
                  rowCellsBuilder: (BuildContext context, int rowIdx) {
                    UserInfo user = _controller.rows.value[rowIdx] as UserInfo;
                    return [
                      Text("${user.id}"),
                      Text("${user.name} ${user.lastName}"),
                      Text(user.gender),
                      Text(
                        user.address,
                      ),
                    ];
                  }),
            ),
            Container(
              color: Theme.of(context).appBarTheme.backgroundColor,
              child: Center(
                child: Text(_msg),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showSnakeBarMsg(String msg) {
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
  },
  {
    "id": 12,
    "name": "Thatcher",
    "last_name": "Manuello",
    "gender": "Male",
    "address": "426 Knutson Lane"
  },
  {
    "id": 13,
    "name": "Guendolen",
    "last_name": "Mattersley",
    "gender": "Female",
    "address": "5 Swallow Terrace"
  },
  {
    "id": 14,
    "name": "Ola",
    "last_name": "Slaughter",
    "gender": "Polygender",
    "address": "27 Barnett Street"
  },
  {
    "id": 15,
    "name": "Raquela",
    "last_name": "Foyston",
    "gender": "Female",
    "address": "00 Katie Hill"
  },
  {
    "id": 16,
    "name": "Caralie",
    "last_name": "Gawen",
    "gender": "Female",
    "address": "26571 Continental Park"
  },
  {
    "id": 17,
    "name": "Marsha",
    "last_name": "Jindra",
    "gender": "Female",
    "address": "32 Helena Junction"
  },
  {
    "id": 18,
    "name": "Minni",
    "last_name": "Bartolomucci",
    "gender": "Female",
    "address": "0 Esch Road"
  },
  {
    "id": 19,
    "name": "Gerik",
    "last_name": "Morgan",
    "gender": "Agender",
    "address": "3717 Spaight Parkway"
  },
  {
    "id": 20,
    "name": "Dickie",
    "last_name": "Rippon",
    "gender": "Male",
    "address": "267 Oneill Alley"
  },
  {
    "id": 21,
    "name": "Nevin",
    "last_name": "Oakenfield",
    "gender": "Polygender",
    "address": "98 Hoard Park"
  },
  {
    "id": 22,
    "name": "Sharia",
    "last_name": "Medmore",
    "gender": "Female",
    "address": "08580 Dahle Crossing"
  },
  {
    "id": 23,
    "name": "Tamra",
    "last_name": "Cardnell",
    "gender": "Female",
    "address": "2551 Carey Center"
  },
  {
    "id": 24,
    "name": "Rose",
    "last_name": "McClintock",
    "gender": "Female",
    "address": "8 Hoard Road"
  },
  {
    "id": 25,
    "name": "Danit",
    "last_name": "O'Neal",
    "gender": "Female",
    "address": "54 Novick Way"
  },
  {
    "id": 26,
    "name": "Pryce",
    "last_name": "Cason",
    "gender": "Male",
    "address": "8 Spohn Court"
  },
  {
    "id": 27,
    "name": "Aurelie",
    "last_name": "Adran",
    "gender": "Female",
    "address": "66865 Melrose Drive"
  },
  {
    "id": 28,
    "name": "Germana",
    "last_name": "Rupp",
    "gender": "Female",
    "address": "865 Novick Plaza"
  },
  {
    "id": 29,
    "name": "Natal",
    "last_name": "Oakton",
    "gender": "Genderfluid",
    "address": "7850 Johnson Park"
  },
  {
    "id": 30,
    "name": "Calypso",
    "last_name": "Kerswell",
    "gender": "Non-binary",
    "address": "80 Commercial Hill"
  },
  {
    "id": 31,
    "name": "Leroy",
    "last_name": "Kingcote",
    "gender": "Male",
    "address": "47775 Russell Plaza"
  },
  {
    "id": 32,
    "name": "Urbano",
    "last_name": "Freke",
    "gender": "Male",
    "address": "6 Clemons Way"
  },
  {
    "id": 33,
    "name": "Kile",
    "last_name": "Bradnocke",
    "gender": "Male",
    "address": "098 Larry Drive"
  },
  {
    "id": 34,
    "name": "Catharina",
    "last_name": "Darrell",
    "gender": "Female",
    "address": "72 Mayfield Plaza"
  },
  {
    "id": 35,
    "name": "Aldrich",
    "last_name": "Berard",
    "gender": "Male",
    "address": "93478 Carioca Center"
  },
  {
    "id": 36,
    "name": "Thorin",
    "last_name": "Bonnaire",
    "gender": "Male",
    "address": "4533 Moulton Park"
  },
  {
    "id": 37,
    "name": "Maurice",
    "last_name": "McCurtin",
    "gender": "Genderfluid",
    "address": "62334 Menomonie Place"
  },
  {
    "id": 38,
    "name": "Ardeen",
    "last_name": "Warry",
    "gender": "Female",
    "address": "3603 Mariners Cove Plaza"
  },
  {
    "id": 39,
    "name": "Arni",
    "last_name": "Brownlie",
    "gender": "Male",
    "address": "98 Dunning Crossing"
  },
  {
    "id": 40,
    "name": "Perice",
    "last_name": "Kivits",
    "gender": "Male",
    "address": "86 Stone Corner Circle"
  },
  {
    "id": 41,
    "name": "Amye",
    "last_name": "Kimbrey",
    "gender": "Female",
    "address": "10 Eastlawn Crossing"
  },
  {
    "id": 42,
    "name": "Tracie",
    "last_name": "Sutlieff",
    "gender": "Female",
    "address": "10 Comanche Circle"
  },
  {
    "id": 43,
    "name": "Kial",
    "last_name": "Viegas",
    "gender": "Female",
    "address": "659 Buena Vista Alley"
  },
  {
    "id": 44,
    "name": "Ramona",
    "last_name": "Charteris",
    "gender": "Female",
    "address": "870 Stang Crossing"
  },
  {
    "id": 45,
    "name": "Burch",
    "last_name": "Lettice",
    "gender": "Male",
    "address": "8897 Daystar Pass"
  },
  {
    "id": 46,
    "name": "Sherilyn",
    "last_name": "Foxhall",
    "gender": "Female",
    "address": "823 Sommers Avenue"
  },
  {
    "id": 47,
    "name": "Goran",
    "last_name": "Harpin",
    "gender": "Male",
    "address": "468 Merry Circle"
  }
];
