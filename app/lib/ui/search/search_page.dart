import 'dart:async';
import 'dart:math';
import 'package:auto_route/auto_route.dart';
import '../../app.dart';
import 'bloc/search.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends BasePageState<SearchPage, SearchBloc> {
  // ====== GAME VARIABLES ======
  static double birdY = 0; // vị trí chim (trục Y)
  double time = 0;
  double height = 0;
  double initialHeight = birdY;
  bool gameHasStarted = false;

  // Ống
  double pipeX = 2; // vị trí pipe theo trục X
  double topPipeHeight = 0.4; // chiều cao ống trên (0->1)
  final double pipeWidth = 0.2;
  final double gap = 0.35; // khoảng trống giữa ống trên/dưới

  int score = 0;
  Timer? gameTimer;

  final Random random = Random();

  void startGame() {
    gameHasStarted = true;
    time = 0;
    initialHeight = birdY;

    gameTimer = Timer.periodic(const Duration(milliseconds: 60), (timer) {
      time += 0.04;
      height = -4.9 * time * time + 2.8 * time;

      setState(() {
        birdY = initialHeight - height;
        pipeX -= 0.05;
      });

      // Ống đi hết màn hình
      if (pipeX < -2) {
        pipeX = 2;
        topPipeHeight = random.nextDouble() * 0.5 + 0.2; // random từ 0.2->0.7
        score++;
      }

      // Game Over
      if (birdY > 1 || birdY < -1 || checkCollision()) {
        timer.cancel();
        gameHasStarted = false;
        showGameOverDialog();
      }
    });
  }

  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdY;
    });
  }

  void resetGame() {
    setState(() {
      birdY = 0;
      pipeX = 2;
      score = 0;
      gameHasStarted = false;
      time = 0;
      topPipeHeight = random.nextDouble() * 0.5 + 0.2;
    });
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Game Over"),
        content: Text("Điểm: $score"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetGame();
            },
            child: const Text("Chơi lại"),
          )
        ],
      ),
    );
  }

  bool checkCollision() {
    double birdLeft = -0.05;
    double birdRight = 0.05;

    double pipeLeft = pipeX - pipeWidth / 2;
    double pipeRight = pipeX + pipeWidth / 2;

    double topPipeBottom = -1 + topPipeHeight;
    double bottomPipeTop = 1 - (1 - topPipeHeight - gap);

    if (birdRight > pipeLeft && birdLeft < pipeRight) {
      if (birdY < topPipeBottom || birdY > bottomPipeTop) {
        return true;
      }
    }
    return false;
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context) {
    return CommonScaffold(
      appBar: AppBar(title: const Text("Flappy Bird")),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (!gameHasStarted) {
            startGame();
          } else {
            jump();
          }
        },
        child: Stack(
          children: [
            // ================== BIRD ==================
            AnimatedContainer(
              alignment: Alignment(0, birdY),
              duration: const Duration(milliseconds: 0),
              child: const Icon(Icons.flutter_dash, size: 60, color: Colors.blue),
            ),

            // ================== PIPE (trên) ==================
            AnimatedContainer(
              alignment: Alignment(pipeX, -1 + topPipeHeight / 2),
              duration: const Duration(milliseconds: 0),
              child: Container(
                width: MediaQuery.of(context).size.width * pipeWidth,
                height: MediaQuery.of(context).size.height * topPipeHeight / 2,
                color: Colors.green,
              ),
            ),

            // ================== PIPE (dưới) ==================
            AnimatedContainer(
              alignment: Alignment(pipeX, 1 - (1 - topPipeHeight - gap) / 2),
              duration: const Duration(milliseconds: 0),
              child: Container(
                width: MediaQuery.of(context).size.width * pipeWidth,
                height: MediaQuery.of(context).size.height * (1 - topPipeHeight - gap) / 2,
                color: Colors.green,
              ),
            ),

            // ================== START TEXT ==================
            if (!gameHasStarted)
              const Center(
                child: Text(
                  "TAP TO PLAY",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),

            // ================== SCORE ==================
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "Điểm: $score",
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
