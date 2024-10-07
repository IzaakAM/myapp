import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/providers/score_provider.dart';
import 'package:myapp/widgets/dialogs/gameOverDialog.dart';
import 'package:provider/provider.dart';
import 'package:myapp/constants/colors.dart';
import 'package:myapp/widgets/dialogs/winDialog.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  List<List<int>> board = List.generate(4, (_) => List.generate(4, (_) => 0));
  bool isGameOver = false;
  bool isGameWin = false;
  bool isGameOverDialogShown = false;

  @override
  void initState() {
    super.initState();
    addNewTile();
    addNewTile();
  }

  void resetBoard() {
    setState(() {
      board = List.generate(4, (_) => List.generate(4, (_) => 0));
      isGameOver = false;
      isGameWin = false;
      addNewTile();
      addNewTile();
    });
    Provider.of<ScoreProvider>(context, listen: false).updateScore(1);
  }

  double calculateFontSize(int value) {
    if (value > 9999) return MediaQuery.of(context).size.width * 0.06;
    if (value > 999) return MediaQuery.of(context).size.width * 0.08;
    return MediaQuery.of(context).size.width * 0.1;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScoreProvider>(builder: (context, scoreProvider, _) {
      if (scoreProvider.score == -1) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          resetBoard();
        });
      }

      return Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: GestureDetector(
            onPanEnd: (details) {
              double velocityX = details.velocity.pixelsPerSecond.dx;
              double velocityY = details.velocity.pixelsPerSecond.dy;

              // Seuil minimum pour détecter un mouvement significatif
              double sensitivity = 00;

              if (velocityX.abs() > velocityY.abs()) {
                // Détection d'un mouvement horizontal
                if (velocityX > sensitivity) {
                  handleKeyPress(LogicalKeyboardKey
                      .arrowRight); // Mouvement vers la droite
                } else if (velocityX < -sensitivity) {
                  handleKeyPress(
                      LogicalKeyboardKey.arrowLeft); // Mouvement vers la gauche
                }
              } else {
                // Détection d'un mouvement vertical
                if (velocityY > sensitivity) {
                  handleKeyPress(
                      LogicalKeyboardKey.arrowDown); // Mouvement vers le bas
                } else if (velocityY < -sensitivity) {
                  handleKeyPress(
                      LogicalKeyboardKey.arrowUp); // Mouvement vers le haut
                }
              }
            },
            child: RawKeyboardListener(
              focusNode: FocusNode(),
              autofocus: true,
              onKey: (event) {
                if (!isGameOver && event is RawKeyDownEvent) {
                  // Désactiver les touches de clavier si le jeu est terminé
                  handleKeyPress(event.logicalKey);
                }
              },
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1.0,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                ),
                itemCount: 16,
                itemBuilder: (context, index) {
                  int row = index ~/ 4;
                  int col = index % 4;
                  return SizedBox(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(),
                        color: TileColors.getColor(board[row][col]),
                      ),
                      child: Center(
                        child: Text(
                            board[row][col] == 0
                                ? ''
                                : board[row][col].toString(),
                            style: TextStyle(
                              fontSize: calculateFontSize(board[row][col]),
                            )),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
    });
  }

  bool checkForGameOverCondition() {
    // Vérifier s'il y a des cases vides
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (board[i][j] == 0) {
          return false; // Il y a une case vide, donc le jeu continue
        }
      }
    }
    // Vérifier s'il y a des cases adjacentes avec la même valeur (mouvements possibles)
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (i > 0 && board[i][j] == board[i - 1][j]) {
          return false; // Mouvement possible vers le haut
        }
        if (i < 3 && board[i][j] == board[i + 1][j]) {
          return false; // Mouvement possible vers le bas
        }
        if (j > 0 && board[i][j] == board[i][j - 1]) {
          return false; // Mouvement possible vers la gauche
        }
        if (j < 3 && board[i][j] == board[i][j + 1]) {
          return false; // Mouvement possible vers la droite
        }
      }
    }
    isGameOver = true;
    showGameOverDialog(context, resetBoard);
    return true;
  }

  void checkForWinCondition() {
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (board[i][j] == 2048 && !isGameWin) {
          isGameWin = true;
          showWinDialog(
              context, resetBoard); // Afficher le dialogue de victoire
          return;
        }
      }
    }
  }

  void handleKeyPress(LogicalKeyboardKey key) {
    if (isGameOver) return; // Si le jeu est terminé, ne pas réagir aux touches
    List<List<int>> previousBoard =
        List.generate(4, (_) => List.generate(4, (j) => board[_][j]));

    if (key == LogicalKeyboardKey.arrowUp) {
      moveUp();
    } else if (key == LogicalKeyboardKey.arrowDown) {
      moveDown();
    } else if (key == LogicalKeyboardKey.arrowLeft) {
      moveLeft();
    } else if (key == LogicalKeyboardKey.arrowRight) {
      moveRight();
    }

    if (hasBoardChanged(previousBoard)) {
      addNewTile();
      checkForWinCondition();
      checkForGameOverCondition();
    }

  }

  bool hasBoardChanged(List<List<int>> previousBoard) {
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (board[i][j] != previousBoard[i][j]) {
          return true;
        }
      }
    }
    return false;
  }

  void addNewTile() {
    List<int> emptyCells = [];
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (board[i][j] == 0) {
          emptyCells.add(i * 4 + j);
        }
      }
    }
    if (emptyCells.isNotEmpty) {
      int randomIndex = Random().nextInt(emptyCells.length);
      int row = emptyCells[randomIndex] ~/ 4;
      int col = emptyCells[randomIndex] % 4;
      setState(() {
        board[row][col] = Random().nextInt(10) < 9
            ? 2
            : 4; // 90% chance of 2, 10% chance of 4
      });
    }
  }

// Function to move tiles up
  void moveUp() {
    int scoreIncrement = 0;
    setState(() {
      for (int col = 0; col < 4; col++) {
        for (int row = 1; row < 4; row++) {
          if (board[row][col] != 0) {
            int currentRow = row;
            while (currentRow > 0 && board[currentRow - 1][col] == 0) {
              board[currentRow - 1][col] = board[currentRow][col];
              board[currentRow][col] = 0;
              currentRow--;
            }
            if (currentRow > 0 &&
                board[currentRow - 1][col] == board[currentRow][col]) {
              board[currentRow - 1][col] *= 2;
              scoreIncrement += board[currentRow - 1][col];
              board[currentRow][col] = 0;
            }
          }
        }
      }
      Provider.of<ScoreProvider>(context, listen: false)
          .updateScore(scoreIncrement); // Update score using provider
    });
  }

// Function to move tiles down
  void moveDown() {
    int scoreIncrement = 0;
    setState(() {
      for (int col = 0; col < 4; col++) {
        for (int row = 2; row >= 0; row--) {
          if (board[row][col] != 0) {
            int currentRow = row;
            while (currentRow < 3 && board[currentRow + 1][col] == 0) {
              board[currentRow + 1][col] = board[currentRow][col];
              board[currentRow][col] = 0;
              currentRow++;
            }
            if (currentRow < 3 &&
                board[currentRow + 1][col] == board[currentRow][col]) {
              board[currentRow + 1][col] *= 2;
              scoreIncrement += board[currentRow + 1][col];
              board[currentRow][col] = 0;
            }
          }
        }
      }
      Provider.of<ScoreProvider>(context, listen: false)
          .updateScore(scoreIncrement); // Update score using provider
    });
  }

// Function to move tiles left
  void moveLeft() {
    int scoreIncrement = 0;
    setState(() {
      for (int row = 0; row < 4; row++) {
        for (int col = 1; col < 4; col++) {
          if (board[row][col] != 0) {
            int currentCol = col;
            while (currentCol > 0 && board[row][currentCol - 1] == 0) {
              board[row][currentCol - 1] = board[row][currentCol];
              board[row][currentCol] = 0;
              currentCol--;
            }
            if (currentCol > 0 &&
                board[row][currentCol - 1] == board[row][currentCol]) {
              board[row][currentCol - 1] *= 2;
              scoreIncrement += board[row][currentCol - 1];
              board[row][currentCol] = 0;
            }
          }
        }
      }
      Provider.of<ScoreProvider>(context, listen: false)
          .updateScore(scoreIncrement); // Update score using provider
    });
  }

// Function to move tiles right
  void moveRight() {
    int scoreIncrement = 0;
    setState(() {
      for (int row = 0; row < 4; row++) {
        for (int col = 2; col >= 0; col--) {
          if (board[row][col] != 0) {
            int currentCol = col;
            while (currentCol < 3 && board[row][currentCol + 1] == 0) {
              board[row][currentCol + 1] = board[row][currentCol];
              board[row][currentCol] = 0;
              currentCol++;
            }
            if (currentCol < 3 &&
                board[row][currentCol + 1] == board[row][currentCol]) {
              board[row][currentCol + 1] *= 2;
              scoreIncrement += board[row][currentCol + 1];
              board[row][currentCol] = 0;
            }
          }
        }
      }
      Provider.of<ScoreProvider>(context, listen: false)
          .updateScore(scoreIncrement); // Update score using provider
    });
  }
}
