import 'package:flutter/material.dart';
import '../models/history_entry.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _counter = 0;
  final List<HistoryEntry> _history = [];

  void _addToHistory(String action) {
    _history.insert(
      0,
      HistoryEntry(action: action, value: _counter, time: DateTime.now()),
    );
    if (_history.length > 10) {
      _history.removeLast();
    }
  }

  void _increment() {
    setState(() {
      _counter++;
      _addToHistory('+1');
    });
  }

  void _decrement() {
    if (_counter == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Значення не може бути від\'ємним')),
      );
      return;
    }
    setState(() {
      _counter--;
      _addToHistory('−1');
    });
  }

  void _reset() {
    setState(() {
      _counter = 0;
      _addToHistory('Скинути');
    });
  }

  String _formatTime(DateTime t) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(t.hour)}:${two(t.minute)}:${two(t.second)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final highlight = _counter != 0 && _counter % 10 == 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Лічильник із історією')),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Text(
            '$_counter',
            style: theme.textTheme.displayLarge?.copyWith(
              color: highlight ? Colors.deepOrange : null,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: _decrement, child: const Text('−')),
              const SizedBox(width: 12),
              ElevatedButton(onPressed: _reset, child: const Text('Скинути')),
              const SizedBox(width: 12),
              ElevatedButton(onPressed: _increment, child: const Text('+')),
            ],
          ),
          const Divider(height: 32),
          Expanded(
            child: _history.isEmpty
                ? const Center(child: Text('Історія порожня'))
                : ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final e = _history[index];
                return ListTile(
                  leading: const Icon(Icons.history),
                  title: Text('${e.action} → ${e.value}'),
                  trailing: Text(_formatTime(e.time)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}