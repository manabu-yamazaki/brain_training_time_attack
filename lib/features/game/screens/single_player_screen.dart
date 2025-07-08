import 'package:flutter/material.dart';
import 'dart:math';

class SinglePlayerScreen extends StatefulWidget {
  const SinglePlayerScreen({super.key});

  @override
  State<SinglePlayerScreen> createState() => _SinglePlayerScreenState();
}

class _SinglePlayerScreenState extends State<SinglePlayerScreen> {
  int _score = 0;
  int _timeLeft = 60; // 60秒の制限時間
  bool _isGameActive = false;
  bool _isGameOver = false;

  // 計算問題用の変数
  int _numberA = 0;
  int _numberB = 0;
  String _operator = '+';
  int _correctAnswer = 0;
  final TextEditingController _answerController = TextEditingController();
  String _resultMessage = '';
  bool _isCorrect = false;

  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _isGameActive = true;
      _isGameOver = false;
      _score = 0;
      _timeLeft = 60;
      _resultMessage = '';
      _isCorrect = false;
    });
    _generateNewProblem();
    _startTimer();
  }

  void _generateNewProblem() {
    // ランダムな数値を生成（1-20の範囲）
    _numberA = _random.nextInt(20) + 1;
    _numberB = _random.nextInt(20) + 1;

    // ランダムな演算子を選択
    final operators = ['+', '-', '×', '÷'];
    _operator = operators[_random.nextInt(operators.length)];

    // 正解を計算
    switch (_operator) {
      case '+':
        _correctAnswer = _numberA + _numberB;
        break;
      case '-':
        _correctAnswer = _numberA - _numberB;
        break;
      case '×':
        _correctAnswer = _numberA * _numberB;
        break;
      case '÷':
        // 割り算の場合は整数になるように調整
        _numberA = _numberB * (_random.nextInt(10) + 1);
        _correctAnswer = _numberA ~/ _numberB;
        break;
    }

    // 入力欄をクリア
    _answerController.clear();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _isGameActive) {
        setState(() {
          _timeLeft--;
        });

        if (_timeLeft <= 0) {
          _endGame();
        } else {
          _startTimer();
        }
      }
    });
  }

  void _endGame() {
    setState(() {
      _isGameActive = false;
      _isGameOver = true;
    });
  }

  void _checkAnswer() {
    if (!_isGameActive) return;

    final userAnswer = int.tryParse(_answerController.text);

    if (userAnswer == null) {
      setState(() {
        _resultMessage = '数字を入力してください';
        _isCorrect = false;
      });
      return;
    }

    if (userAnswer == _correctAnswer) {
      setState(() {
        _score += 10;
        _resultMessage = '正解！ +10ポイント';
        _isCorrect = true;
      });

      // 1秒後に次の問題を生成
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted && _isGameActive) {
          setState(() {
            _resultMessage = '';
            _isCorrect = false;
          });
          _generateNewProblem();
        }
      });
    } else {
      setState(() {
        _resultMessage = '不正解。正解は $_correctAnswer でした';
        _isCorrect = false;
      });

      // 2秒後に次の問題を生成
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted && _isGameActive) {
          setState(() {
            _resultMessage = '';
            _isCorrect = false;
          });
          _generateNewProblem();
        }
      });
    }
  }

  void _restartGame() {
    _startGame();
  }

  void _goBackToHome() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ひとりで遊ぶ'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goBackToHome,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ゲーム情報表示
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        'スコア',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '$_score',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '残り時間',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '$_timeLeft',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _timeLeft <= 10
                                  ? Colors.red
                                  : Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ゲームエリア
            Expanded(
              child: _isGameOver ? _buildGameOverScreen() : _buildGameArea(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameArea() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '計算問題に答えよう！',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // 計算問題表示
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$_numberA',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                ),
                const SizedBox(width: 16),
                Text(
                  _operator,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                ),
                const SizedBox(width: 16),
                Text(
                  '$_numberB',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                ),
                const SizedBox(width: 16),
                Text(
                  '=',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: _answerController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                    ),
                    onSubmitted: (_) => _checkAnswer(),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 回答ボタン
          ElevatedButton(
            onPressed: _checkAnswer,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text(
              '回答',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),

          const SizedBox(height: 16),

          // 結果メッセージ
          if (_resultMessage.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isCorrect
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _isCorrect ? Colors.green : Colors.red,
                ),
              ),
              child: Text(
                _resultMessage,
                style: TextStyle(
                  color: _isCorrect ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          const SizedBox(height: 24),
          Text(
            '正解すると +10 ポイント',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGameOverScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.emoji_events,
            size: 100,
            color: Colors.amber,
          ),
          const SizedBox(height: 24),
          Text(
            'ゲーム終了！',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            '最終スコア: $_score',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _restartGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('もう一度遊ぶ'),
              ),
              ElevatedButton(
                onPressed: _goBackToHome,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('ホームに戻る'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
