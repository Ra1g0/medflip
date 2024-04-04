import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Import the audioplayers package
import 'start_game.dart';
import 'dart:io';
import 'instructions.dart';


import 'package:medieval_flip/database_helper.dart';
import 'package:medieval_flip/leaderboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.initializeDatabase();
  runApp(const MainMenu());
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medieval Flip',
      theme: ThemeData(
        primarySwatch: Colors.blue, // the primary mainscreen
      ),
      home: const MainMenuScreen(),
    );
  }
}

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  late AudioPlayer player;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    playMusic();
  }

  // THE AUDIOS
  late AudioPlayer audioPlayer;
  Future<void> initializeAudioPlayer() async {
    audioPlayer = AudioPlayer();
  }

  Future<void> playMusic() async {
    await initializeAudioPlayer();
    await audioPlayer.play(AssetSource('audio/music/background_music.mp3'));
  }

  Future<void> playMusicLoop() async {
    await initializeAudioPlayer();
    audioPlayer.onPlayerComplete.listen((event) {
      playMusic();
    });
  }

  // -------------------------------------------------------------------- TITLES AND LOGO ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/main_menu.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Opacity(
              opacity: 0.8,
              child: Container(
                margin: const EdgeInsets.fromLTRB(50, 50, 50, 50),
                padding: const EdgeInsets.fromLTRB(50, 10, 50, 80),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/black_parchment.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/medieval_flip_logo.png',
                            height: 260,
                            width: 260,
                          ),
                          const Column(
                            children: [
                              Text(
                                'Medieval',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 248, 248, 242),
                                  fontFamily: 'MAXIMILIANZIER',
                                  fontSize: 35.0,
                                  letterSpacing: 2.0,
                                  shadows: [
                                    Shadow(
                                      color: Color.fromARGB(255, 15, 15, 15),
                                      blurRadius: 5,
                                      offset: Offset(6, 6),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'Flip',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 249, 249, 249),
                                  fontFamily: 'MAXIMILIANZIER',
                                  fontSize: 35.0,
                                  letterSpacing: 2.0,
                                  shadows: [
                                    Shadow(
                                      color: Color.fromARGB(255, 15, 15, 14),
                                      blurRadius: 2,
                                      offset: Offset(6, 6),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // 4 BUTTONS
                      const SizedBox(height: 20),
                      medievalButtonWidget(
                        'Start Game', // START BUTTON
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const StartGameScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      medievalButtonWidget(
                        'Instructions', // INSTRUCTION BUTTON
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const InstructionScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      medievalButtonWidget(
                        'Leaderboard', // balang araw maging icon
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const LeaderboardScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      medievalButtonWidget(
                        'Exit Game', // EXIT GAME BUTTON
                        () {
                          exit(0); // Close the app
                        },
                      ),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// DESIGN FOR BUTTON
Widget medievalButtonWidget(
  String label,
  VoidCallback onPressed,
) {
  return SizedBox(
    height: 50,
    width: 170,
    child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
          overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.white.withOpacity(0.5);
            } else if (states.contains(MaterialState.hovered)) {
              return Colors.white.withOpacity(0.2);
            }
            return Colors.transparent.withOpacity(0.1);
          }),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.all(10),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Augusta',
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        )),
  );
}


