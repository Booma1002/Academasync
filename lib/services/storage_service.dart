import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_model.dart';
import '../models/roadmap_model.dart';

class StorageService {
  static const String _todoKey = 'jade_todos';
  static const String _roadmapKey = 'jade_roadmap';
  static const String _themeKey = 'jade_theme';

  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call init() in main.dart');
    }
    return _prefs!;
  }

  Future<void> saveTodos(List<Todo> todos) async {
    final String jsonString = jsonEncode(todos.map((t) => t.toJson()).toList());
    await prefs.setString(_todoKey, jsonString);
  }

  List<Todo> loadTodos() {
    final String? jsonString = prefs.getString(_todoKey);
    if (jsonString == null) return [];
    try {
      final List<dynamic> decodedList = jsonDecode(jsonString);
      return decodedList.map((json) => Todo.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveRoadmap(RoadmapData data) async {
    await prefs.setString(_roadmapKey, jsonEncode(data.toJson()));
  }

  RoadmapData loadRoadmap() {
    final String? jsonString = prefs.getString(_roadmapKey);
    if (jsonString == null) return const RoadmapData();
    try {
      return RoadmapData.fromJson(jsonDecode(jsonString));
    } catch (e) {
      return const RoadmapData();
    }
  }

  Future<void> saveTheme(String themeName) async {
    await prefs.setString(_themeKey, themeName);
  }

  String loadTheme() {
    return prefs.getString(_themeKey) ?? 'dark';
  }

  Future<void> wipeData() async {
    await prefs.clear();
  }

  /*----------------------------------------------*\
  |  EXPORT: Now returns a simple Map              |
  \*----------------------------------------------*/
  String exportFullState() {
    final Map<String, dynamic> fullState = {
      _todoKey: prefs.getString(_todoKey),
      _roadmapKey: prefs.getString(_roadmapKey),
      _themeKey: prefs.getString(_themeKey),
    };
    return jsonEncode(fullState);
  }

  /*----------------------------------------------*\
  |  IMPORT: Flexible enough to handle raw roadmap |
  |  JSON or full system backups.                  |
  \*----------------------------------------------*/
  Future<void> importFullState(String jsonString) async {
    final dynamic decoded = jsonDecode(jsonString);

    if (decoded is Map<String, dynamic>) {
      /*----------------------------------------------*\
      |  Case A: Full System Backup                    |
      \*----------------------------------------------*/
      if (decoded.containsKey(_roadmapKey) || decoded.containsKey(_todoKey)) {
        if (decoded[_todoKey] != null) {
          await prefs.setString(_todoKey, decoded[_todoKey].toString());
        }
        if (decoded[_roadmapKey] != null) {
          await prefs.setString(_roadmapKey, decoded[_roadmapKey].toString());
        }
        if (decoded[_themeKey] != null) {
          await prefs.setString(_themeKey, decoded[_themeKey].toString());
        }
      } 
      /*----------------------------------------------*\
      |  Case B: Raw Roadmap JSON (User's Example)     |
      \*----------------------------------------------*/
      else if (decoded.containsKey('startDate') || decoded.containsKey('burnedTokens')) {
        await prefs.setString(_roadmapKey, jsonString);
      }
    }
  }
}
