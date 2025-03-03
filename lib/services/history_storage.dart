

import 'package:shared_preferences/shared_preferences.dart';

class HistoryStorage {
  static const _historyKey = 'chat_history';

  

  Future<List<String>> getHistory() async {
  try {
    print("Trying to fetch history...");
    final prefs = await SharedPreferences.getInstance();
    final List<String>? storedHistory = prefs.getStringList(_historyKey);
    print("History fetched: $storedHistory");
    return storedHistory ?? [];
  } catch (e) {
    print("Error fetching history: $e");
    return [];
  }
}


  Future<void> addPrompt(String prompt) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = await getHistory();

      // Avoid duplicates and limit history length if necessary
      if (history.contains(prompt)) return;

      history.insert(0, prompt); // Newest at the top
      await prefs.setStringList(_historyKey, history);
      print("Saved new prompt: $prompt");
    } catch (e) {
      print("Error saving prompt: $e");
    }
  }

  Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
    } catch (e) {
      print("Error clearing history: $e");
    }
  }
}
