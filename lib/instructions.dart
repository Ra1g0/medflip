import 'package:flutter/material.dart';

class InstructionScreen extends StatelessWidget {
  const InstructionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/instruction_menu.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Center the content within the container
          Center(
            child: Container(
              padding: const EdgeInsets.all(80),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/result_box.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  const Text(
                    'Instructions',
                    style: TextStyle(
                      fontFamily: 'ChampFleury',
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 4, 4, 4),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Points Section
                  Column(
                    children: [
                      Image.asset(
                        'assets/icons/score.png',
                        height: 32,
                        width: 32,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Points',
                        style: TextStyle(
                          fontFamily: 'ChampFleury',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "In Medieval Flip, the score typically represents the player's performance. The score is incremented when the player successfully matches two identical cards.",
                        style: TextStyle(
                          fontFamily: 'ChampFleury',
                          fontSize: 12,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                  // Moves Section
                  Column(
                    children: [
                      Image.asset(
                        'assets/icons/moves.png',
                        height: 32,
                        width: 32,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Moves',
                        style: TextStyle(
                          fontFamily: 'ChampFleury',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Moves refer to the actions taken by the player to reveal and match pairs of cards in the game. Each time the player selects two cards to reveal, it counts as one move.",
                        style: TextStyle(
                          fontFamily: 'ChampFleury',
                          fontSize: 12,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                  // Timer Section
                  Column(
                    children: [
                      Image.asset(
                        'assets/icons/timer.png',
                        height: 32,
                        width: 32,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Timer',
                        style: TextStyle(
                          fontFamily: 'ChampFleury',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "The timer in Memory Match measures the elapsed time from the beginning of the game until it is completed.",
                        style: TextStyle(
                          fontFamily: 'ChampFleury',
                          fontSize: 12,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Button to Close
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      'assets/icons/okay_circbutton.png',
                      width: 36,
                      height: 36,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
