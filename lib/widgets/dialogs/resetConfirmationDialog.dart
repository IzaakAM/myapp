import 'package:flutter/material.dart';
import 'package:myapp/providers/score_provider.dart';
import 'package:provider/provider.dart';
import 'package:myapp/constants/strings.dart';

// Function to show the win dialog
Future<void> showResetConfirmationDialog(BuildContext context) {
  return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content:
              const Text(AppStrings.resetGameMessage),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
            ),
            TextButton(
              child: const Text('Confirmer'),
              onPressed: () {
                Provider.of<ScoreProvider>(context, listen: false)
                    .resetScore(); // Réinitialise le score
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
            ),
          ],
        );
      },
    );
  }

