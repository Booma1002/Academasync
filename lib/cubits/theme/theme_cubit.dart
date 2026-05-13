import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/storage_service.dart';

/*----------------------------------------------*\
|  <Sla7ef (2Z2H1G)>                             |
|  Controls the app's visual theme (dark,        |
|  light, cyber) and saves the preference.       |
\*----------------------------------------------*/
class ThemeCubit extends Cubit<String> {
  final StorageService _storage;

  ThemeCubit(this._storage) : super('dark') {
    _loadTheme();
  }

  void _loadTheme() {
    emit(_storage.loadTheme());
  }

  void cycleTheme() {
    const themes = ['dark', 'light', 'cyber'];
    final currentIndex = themes.indexOf(state);
    final nextTheme = themes[(currentIndex + 1) % themes.length];

    emit(nextTheme);
    _storage.saveTheme(nextTheme);
  }
}