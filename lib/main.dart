import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/gameBoard.dart';
import 'widgets/appBar.dart';
import 'providers/score_provider.dart';



void main() {
     runApp(
       ChangeNotifierProvider(
         create: (context) => ScoreProvider(),
         child: const MyApp(),
       ),
     );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 0, 0)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false, // Remove debug banner
      home: const Scaffold(
        appBar: MyAppBar(),
        body: GameBoard()
      ), // Use MyHomePage instead of GameBoard directly
    );
  }
}
