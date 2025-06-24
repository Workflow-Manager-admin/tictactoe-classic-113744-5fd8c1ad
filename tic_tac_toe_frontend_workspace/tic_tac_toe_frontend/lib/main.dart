import 'package:flutter/material.dart';

// App Color Palette
const kPrimaryColor = Color(0xFF1976d2);
const kSecondaryColor = Color(0xFF424242);
const kAccentColor = Color(0xFFffa000);

// Cell States
enum Player { X, O, none }

// Main entrypoint
// PUBLIC_INTERFACE
void main() {
  runApp(const TicTacToeApp());
}

// PUBLIC_INTERFACE
class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.light(
          primary: kPrimaryColor,
          secondary: kSecondaryColor,
          tertiary: kAccentColor,
        ),
        dividerColor: kSecondaryColor.withAlpha((0.2 * 255).toInt()), // Updated for deprecation
        useMaterial3: true,
        fontFamily: 'Roboto',
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: kSecondaryColor,
          displayColor: kPrimaryColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: kAccentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
      home: const TicTacToeScreen(),
    );
  }
}

// PUBLIC_INTERFACE
class TicTacToeScreen extends StatefulWidget {
  const TicTacToeScreen({super.key});

  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  static const int gridSize = 3;
  late List<Player> board;
  Player currentPlayer = Player.X;
  bool gameOver = false;
  Player winner = Player.none;

  @override
  void initState() {
    super.initState();
    _resetBoard();
  }

  void _resetBoard() {
    setState(() {
      board = List.generate(gridSize * gridSize, (index) => Player.none);
      currentPlayer = Player.X;
      winner = Player.none;
      gameOver = false;
    });
  }

  void _handleTap(int index) {
    if (board[index] != Player.none || gameOver) return;
    setState(() {
      board[index] = currentPlayer;
      winner = _checkWinner();
      if (winner != Player.none) {
        gameOver = true;
      } else if (!board.contains(Player.none)) {
        // Draw
        gameOver = true;
      } else {
        currentPlayer = currentPlayer == Player.X ? Player.O : Player.X;
      }
    });
    if (gameOver) {
      _showGameEndDialog();
    }
  }

  Player _checkWinner() {
    List<List<int>> winPatterns = [
      // Rows
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      // Columns
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      // Diagonals
      [0, 4, 8],
      [2, 4, 6],
    ];
    for (var pattern in winPatterns) {
      var a = board[pattern[0]];
      var b = board[pattern[1]];
      var c = board[pattern[2]];
      if (a != Player.none && a == b && b == c) {
        return a;
      }
    }
    return Player.none;
  }

  // PUBLIC_INTERFACE
  Future<void> _showGameEndDialog() async {
    String title;
    String desc;
    if (winner != Player.none) {
      title = "Player ${winner == Player.X ? 'X' : 'O'} Wins!";
      desc = "Congratulations to Player ${winner == Player.X ? "X" : "O"}!";
    } else {
      title = "It's a Draw!";
      desc = "Nobody wins this round.";
    }

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: TextStyle(color: kPrimaryColor)),
        content: Text(desc),
        elevation: 2,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _resetBoard();
            },
            child: Text(
              "Reset",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: kAccentColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCell(int i) {
    String symbol;
    Color color;
    switch (board[i]) {
      case Player.X:
        symbol = 'X';
        color = kPrimaryColor;
        break;
      case Player.O:
        symbol = 'O';
        color = kAccentColor;
        break;
      case Player.none:
        symbol = '';
        color = Colors.transparent;
        break;
    }
    return GestureDetector(
      onTap: () => _handleTap(i),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: kSecondaryColor.withAlpha((0.10 * 255).toInt()), width: 2), // Updated for deprecation
        ),
        alignment: Alignment.center,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          child: Text(
            symbol,
            key: ValueKey(symbol + i.toString()),
            style: TextStyle(
              fontSize: 48,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Height constraints for the minimal centered board
    double boardSize = MediaQuery.of(context).size.shortestSide * 0.74;

    // Determine status message
    String statusText;
    if (gameOver) {
      if (winner != Player.none) {
        statusText = "Player ${winner == Player.X ? 'X' : 'O'} Wins!";
      } else {
        statusText = "It's a Draw!";
      }
    } else {
      statusText = "Player ${currentPlayer == Player.X ? 'X' : 'O'}'s Turn";
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Tic Tac Toe",
          style: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.1,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: "Reset Game",
            icon: Icon(Icons.refresh, color: kAccentColor),
            onPressed: _resetBoard,
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 400,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Game status & indicator
                Padding(
                  padding: const EdgeInsets.only(top: 18, bottom: 22),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 22,
                      color: gameOver
                          ? (winner != Player.none
                              ? kPrimaryColor
                              : kSecondaryColor)
                          : (currentPlayer == Player.X
                              ? kPrimaryColor
                              : kAccentColor),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.75,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Game grid
                Center(
                  child: SizedBox(
                    width: boardSize,
                    height: boardSize,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: gridSize,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                        itemCount: gridSize * gridSize,
                        itemBuilder: (context, index) {
                          return _buildCell(index);
                        },
                      ),
                    ),
                  ),
                ),
                // Spacer
                SizedBox(height: 28),
                // Reset Button
                if (!gameOver)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text("Reset"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kAccentColor,
                      foregroundColor: Colors.white,
                      elevation: 1,
                    ),
                    onPressed: _resetBoard,
                  ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
