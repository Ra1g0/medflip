import 'package:flutter/material.dart';
import 'dart:async';
import 'package:medieval_flip/database_helper.dart';

void main() {
  runApp(const MaterialApp(
    home: StartGameScreen(),
  ));
}

class StartGameScreen extends StatefulWidget {
  const StartGameScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StartGameScreenState createState() => _StartGameScreenState();
}

class _StartGameScreenState extends State<StartGameScreen>
    with TickerProviderStateMixin {
  late Timer timer;
  int timerMinutes = 1;
  int timerSeconds = 0;
  int moves = 0;
  int points = 0;
  late List<bool> cardFlipped;
  late List<bool> cardMatched;
  List<String> frontImages = [
    'assets/images/card01.png',
    'assets/images/card02.png',
    'assets/images/card03.png',
    'assets/images/card04.png',
    'assets/images/card05.png',
    'assets/images/card06.png',
    'assets/images/card01.png',
    'assets/images/card02.png',
    'assets/images/card03.png',
    'assets/images/card04.png',
    'assets/images/card05.png',
    'assets/images/card06.png',
  ];
  int? firstFlippedIndex;

  late List<AnimationController> _animationControllers;

  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), _handleTimerTick);
    frontImages.shuffle();
    cardFlipped = List.filled(12, false);
    cardMatched = List.filled(12, false);
    _animationControllers = List.generate(
      12,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

// ---------------------------------------------------------------- BACKGROUND AND THE GRID FOR 4X4 CARDS ----------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/game_background.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 0),
              _buildTitle(),
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      30,
                      0,
                      30,
                      0,
                    ),
                    child: GridView.extent(
                      childAspectRatio: 0.6,
                      maxCrossAxisExtent: 120, // Maximum width of each card
                      mainAxisSpacing: 15, // Spacing between rows
                      crossAxisSpacing: 15, // Spacing between columns
                      children: List.generate(12, _buildCard),
                    )),
              ),
              const SizedBox(height: 10),
              _buildBottomRow(),
            ],
          ),
        ],
      ),
    );
  }

// ---------------------------------------------------------------- TITLE ----------------------------------------------------------------
  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Medieval Flip',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'MAXIMILIANZIER',
              fontSize: 30.0,
              letterSpacing: 2.0,
              shadows: [
                Shadow(
                  color: Colors.black,
                  blurRadius: 2,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 0),
          _buildPointsTimerMovesRow(),
        ],
      ),
    );
  }

// ---------------------------------------------------------------- THE THREE INFORMATION AT THE TOP ----------------------------------------------------------------

  Widget _buildPointsTimerMovesRow() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/result_box.png'),
          fit: BoxFit.fill,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _buildInfoWithIcon(
              'assets/icons/score.png',
              'Score:',
              '$points',
            ),
          ),
          Expanded(
            child: _buildInfoWithIcon(
              'assets/icons/moves.png',
              'Moves:',
              '$moves',
            ),
          ),
          Expanded(
            child: _buildInfoWithIcon(
              'assets/icons/timer.png',
              'Timer:',
              _formatTimer(),
            ),
          ),
        ],
      ),
    );
  }

// ---------------------------------------------------------------- STYLE FOR THE ICONS ON THE TOP ----------------------------------------------------------------

  Widget _buildInfoWithIcon(String iconPath, String label, String value) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(
            iconPath,
            width: 35,
            height: 35,
          ),
        ),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 15, 15, 14),
                fontFamily: 'ChampFleury',
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 14, 14, 14),
                fontFamily: 'ChampFleury',
              ),
            ),
          ],
        ),
      ],
    );
  }

// ---------------------------------------------------------------- THE WIDGET FOR CARDS ----------------------------------------------------------------
  Widget _buildCard(int index) {
    if (cardMatched[index]) {
      return Container();
    } else {
      return GestureDetector(
        onTap: () {
          if (!timer.isActive || cardMatched[index]) {
            return;
          }
          setState(() {
            if (!cardFlipped[index]) {
              cardFlipped[index] = true;
              _animationControllers[index].forward(from: 0.0);
              if (firstFlippedIndex == null) {
                firstFlippedIndex = index;
              } else {
                if (frontImages[firstFlippedIndex!] == frontImages[index]) {
                  points += 2;
                  moves++;
                  _removeMatchedCards(firstFlippedIndex!, index);
                } else {
                  moves++;
                  _flipCardsBack(index, firstFlippedIndex!);
                }
                firstFlippedIndex = null;
              }
            }
          });
        },
        child: AnimatedBuilder(
          animation: _animationControllers[index],
          builder: (context, child) {
            return Transform(
              transform: Matrix4.rotationY(
                _animationControllers[index].value * 3.141592,
              ),
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/cardback01.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Opacity(
                    opacity:
                        _animationControllers[index].value < 0.5 ? 0.0 : 1.0,
                    child: Center(
                      child: Image.asset(
                        cardFlipped[index]
                            ? frontImages[index]
                            : 'assets/images/cardback01.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }
  }

  // ---------------------------------------------------------------- LOGIC FOR REMOVING THE MATCHED CARDS ----------------------------------------------------------------

  void _removeMatchedCards(int index1, int index2) {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        cardMatched[index1] = true;
        cardMatched[index2] = true;

        // Check for the winning condition
        if (cardMatched.every((matched) => matched)) {
          _showGameWonDialog();
        }
      });
    });
  }

  void _flipCardsBack(int index1, int index2) {
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        cardFlipped[index1] = false;
        cardFlipped[index2] = false;

        // Subtract 1 point for the mismatch
        points = points > 0 ? points - 1 : 0;
      });
    });
  }

// ---------------------------------------------------------------- THIS IS THE BUTTON STYLES ----------------------------------------------------------------

  Widget _buildBottomRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildButton(
            'assets/icons/reset_circbutton.png',
            'Reset',
            resetGame,
            const TextStyle(
              color: Colors.white,
              fontFamily: 'ChampFleury',
              fontSize: 20,
            ),
          ),
          const SizedBox(width: 0),
          _buildButton(
            'assets/icons/home_circbutton.png',
            'Home',
            () => Navigator.of(context).pop(),
            const TextStyle(
              color: Colors.white,
              fontFamily: 'ChampFleury',
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

// ---------------------------------------------------------------- THIS IS THE TWO BOTTOM BUTTONS ----------------------------------------------------------------
  Widget _buildButton(
    String iconPath,
    String buttonText,
    VoidCallback onPressed,
    TextStyle textStyle,
  ) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (buttonText == 'Reset')
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(iconPath),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    buttonText,
                    style: textStyle,
                  ),
                ],
              )
            else if (buttonText == 'Home')
              Row(
                children: [
                  Text(
                    buttonText,
                    style: textStyle,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(iconPath),
                      ),
                    ),
                  ),
                ],
              )
            else
              Text(
                buttonText,
                style: textStyle,
              ),
          ],
        ),
      ),
    );
  }

  void _handleTimerTick(Timer timer) {
    setState(() {
      if (timerSeconds > 0) {
        timerSeconds--;
      } else {
        if (timerMinutes > 0) {
          timerMinutes--;
          timerSeconds = 59;
        } else {
          timer.cancel();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showEndGameDialog();
          });
        }
      }
    });
  }

  String _formatTimer() {
    return '${timerMinutes.toString().padLeft(2, '0')}:${timerSeconds.toString().padLeft(2, '0')}';
  }

  void resetGame() {
    setState(() {
      timerMinutes = 1;
      timerSeconds = 0;
      moves = 0;
      points = 0;
      cardFlipped = List.filled(12, false);
      cardMatched = List.filled(12, false);
      firstFlippedIndex = null;
      frontImages.shuffle();
    });
  }

// ---------------------------------------------------------------- THIS IS THE DIALOGBOX WHEN THE GAME ENDS ----------------------------------------------------------------
  void _showEndGameDialog({bool isGameWon = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,

child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/result_box.png'),
                fit: BoxFit.fill,
              ),
            ),
            padding: const EdgeInsets.all(50.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Text(
                  isGameWon ? 'Game Finished' : 'Game Over',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontFamily: 'MAXIMILIANZIER',
                  ),
                ),
                const SizedBox(height: 0),
                Text(
                  'Points: $points',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'ChampFleury',
                  ),
                ),
                Text(
                  'Moves: $moves',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'ChampFleury',
                  ),
                ),
                Text(
                  'Time Remaining: ${_formatTimer()}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'ChampFleury',
                  ),
                ),

                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter name',
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'ChampFleury',
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {

                    submitScore();

                    Navigator.pop(context); // Close the dialog
                    Navigator.popUntil(context,
                        ModalRoute.withName('/')); // Navigate back to main.dart
                  },
                  child: Image.asset(
                    'assets/icons/okay_circbutton.png',
                    width: 100,
                    height: 50,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
),

          
        );
      },
    );
  }

  void _showGameWonDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/result_box.png'),
                fit: BoxFit.fill,
              ),
            ),
            padding: const EdgeInsets.all(50.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Game Finished',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontFamily: 'MAXIMILIANZIER',
                  ),
                ),
                const SizedBox(height: 0),
                Text(
                  'Points: $points',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'ChampFleury',
                  ),
                ),
                Text(
                  'Moves: $moves',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'ChampFleury',
                  ),
                ),
                Text(
                  'Time Remaining: ${_formatTimer()}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'ChampFleury',
                  ),
                ),

                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter name',
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'ChampFleury',
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {

                    submitScore();
                    
                    Navigator.pop(context); // Close the dialog
                    Navigator.popUntil(context,
                        ModalRoute.withName('/')); // Navigate back to main.dart
                  },
                  child: Image.asset(
                    'assets/icons/okay_circbutton.png',
                    width: 100,
                    height: 50,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
),
          
        );
      },
    );
  }

  void submitScore() async {
    // add data to firebase
    String name = _nameController.text;
    var score = points;

    if (name.isNotEmpty && score > 0) {
      await DatabaseHelper.insertPlayerScore(name, score);
    }
  }
}
