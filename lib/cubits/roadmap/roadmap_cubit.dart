import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/roadmap_model.dart';
import '../../services/storage_service.dart';

/*----------------------------------------------*\
|  <Sla7ef (2Z2H1G)>                             |
|  Controls the 12-month grid logic and start    |
|  date for Delta calculations.                  |
\*----------------------------------------------*/
class RoadmapCubit extends Cubit<RoadmapData> {
  final StorageService _storage;

  RoadmapCubit(this._storage) : super(RoadmapData()) {
    refresh();
  }

  void refresh() {
    emit(_storage.loadRoadmap());
  }

  void setStartDate(DateTime date) {
    final updated = RoadmapData(startDate: date.toIso8601String(), burnedTokens: state.burnedTokens);
    _storage.saveRoadmap(updated);
    emit(updated);
  }

  void toggleToken(String tokenId) {
    final tokens = List<String>.from(state.burnedTokens);
    if (tokens.contains(tokenId)) {
      tokens.remove(tokenId);
    } else {
      tokens.add(tokenId);
    }
    final updated = RoadmapData(startDate: state.startDate, burnedTokens: tokens);
    _storage.saveRoadmap(updated);
    emit(updated);
  }
}