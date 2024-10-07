import 'package:flutter/material.dart';
import 'package:myapp/providers/score_provider.dart';
import 'package:provider/provider.dart';
import 'package:myapp/constants/strings.dart';

// Function to show the win dialog
Future<void> showWinDialog(BuildContext context, Function resetBoard) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // Empêche la fermeture en appuyant à l'extérieur
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Victoire !'),
        content: const Text(AppStrings.winMessage),
        actions: <Widget>[
          TextButton(
            child: const Text('Recommencer'),
            onPressed: () {
              Provider.of<ScoreProvider>(context, listen: false).resetScore();
              resetBoard(); // Réinitialiser la grille
              Navigator.of(context).pop(); // Fermer la boîte de dialogue
            },
          ),
          TextButton(
            child: const Text('Continuer'),
            onPressed: () {
              Navigator.of(context).pop(); // Fermer la boîte de dialogue
            },
          ),
        ],
      );
    },
  );
}
