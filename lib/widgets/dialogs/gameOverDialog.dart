import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/score_provider.dart';
import 'package:myapp/constants/strings.dart';

// Function to show the Game Over dialog
Future<void> showGameOverDialog(BuildContext context, Function resetBoard) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Game Over'),
        content: const Text(AppStrings.gameOverMessage),
        actions: <Widget>[
          TextButton(
            child: const Text('Recommencer'),
            onPressed: () {
              // Réinitialiser le score via le ScoreProvider
              Provider.of<ScoreProvider>(context, listen: false).resetScore();
              resetBoard(); // Réinitialiser la grille
              Navigator.of(context).pop(); // Fermer la boîte de dialogue
            },
          ),
        ],
      );
    },
  );
}
