import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/score_provider.dart';

// Function to show the Game Over dialog
Future<void> showHighScoreDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Meilleurs scores'),
          content: Consumer<ScoreProvider>(
            builder: (context, scoreProvider, _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (scoreProvider.highScores.isEmpty)
                    const Text('Aucun score enregistré.'),
                  if (scoreProvider.highScores.isNotEmpty)
                    ...scoreProvider.highScores
                        .map((score) => Text('$score')),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
            ),
          ],
        );
      },
      );
}
