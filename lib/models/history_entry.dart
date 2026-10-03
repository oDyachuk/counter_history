class HistoryEntry {
  const HistoryEntry({
    required this.action,
    required this.value,
    required this.time,
  });

  final String action; // '+1', '−1', 'Скинути'
  final int value; // значення після дії
  final DateTime time;
}
