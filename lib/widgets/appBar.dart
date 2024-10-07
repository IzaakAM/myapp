import 'package:flutter/material.dart';
import 'package:myapp/providers/score_provider.dart';
import 'package:provider/provider.dart';
import 'package:myapp/widgets/dialogs/highScoreDialog.dart';
import 'package:myapp/widgets/dialogs/resetConfirmationDialog.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);


  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.red[300], // Slightly more red color
      toolbarHeight: 80, // Increased height
      title: const Text(
        '2048',
        style: TextStyle(
          fontSize: 36, // Larger font size
          fontWeight: FontWeight.bold, // Bolder font weight
        ),
      ),
      actions: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Consumer<ScoreProvider>(
              builder: (context, scoreProvider, _) {
                return Text(
                  'Score: ${scoreProvider.score}',
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                );
              },
            ),
          ),
        ),
        // Reset button with confirmation dialog
        IconButton(
          iconSize: 40, // Larger icon size
          icon: const Icon(Icons.refresh),
          onPressed: () {
            showResetConfirmationDialog(
                context); // Affiche la boîte de dialogue
          },
        ),
        IconButton(
          iconSize: 40,
          icon: const Icon(Icons.leaderboard),
          onPressed: () {
            showHighScoreDialog(context);
          },
        ),
      ],
    );
  }
}
