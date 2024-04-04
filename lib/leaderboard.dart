// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:medieval_flip/database_helper.dart';


class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late List<Map<String, dynamic>> _playerScores;

  @override
  void initState() {
    super.initState();
    _fetchPlayerScores();
  }

  Future<void> _fetchPlayerScores() async {
    final List<Map<String, dynamic>> scores = await DatabaseHelper.fetchTopPlayerScores();
    setState(() {
      _playerScores = scores;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [

          //main bg
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/instruction_menu.jpg'),
                fit: BoxFit.cover,
                ),
            ),
          ),

          //container bg img
          Container(
            padding: const EdgeInsets.all(80),
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/result_box.png'),
              fit: BoxFit.contain,
              ),
            ),
            
            //container content
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                //title
                Stack(
                  alignment: Alignment.center,
                  children: [

                    //title logo
                    Image.asset(
                      'assets/icons/medieval_flip_logo.png',
                      width: 100,
                      height: 100,
                      color: const Color.fromRGBO(255, 255, 255, 0.4),
                      colorBlendMode: BlendMode.modulate,
                    ),

                    //title text
                    const Text(
                      'Medieval Flip',
                      style: TextStyle(
                        fontFamily: 'MAXIMILIANZIER',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 4, 4, 4),
                      ),
                    ),
                  ],
                ),

                //Leaderboard text
                const Text(
                  'Leaderboard',
                  style: TextStyle(
                    fontFamily: 'MAXIMILIANZIER',
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Color.fromARGB(255, 4, 4, 4),
                  ),
                ),

                //table
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  
                  child: Table(
                    border: TableBorder.all(color: Colors.transparent),
                    
                    //table values
                    children: [
                      const TableRow(
                        children: [
                          TableCell(child: Center(child: Text('Rank'))),
                          TableCell(child: Center(child: Text('Name'))),
                          TableCell(child: Center(child: Text('Score'))),
                        ],
                      ),
                      for (int i = 0; i < _playerScores.length; i++)
                      TableRow(
                        children: [
                          TableCell(child: Center(child: Text((i + 1).toString()))),
                          TableCell(child: Center(child: Text(_playerScores[i]['PlayerName']))),
                          TableCell(child: Center(child: Text(_playerScores[i]['Score'].toString()))),
                        ],
                      ),
                    ],
                  ),
                ),

                //check button for exit
                Padding(
                  padding: EdgeInsets.only(top: 20.0), 
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      'assets/icons/okay_circbutton.png',
                      width: 36,
                      height: 36,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}