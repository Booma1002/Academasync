import 'package:flutter_bloc/flutter_bloc.dart';

/*----------------------------------------------*\
|  <Sla7ef (2Z2H1G)>                             |
|  Holds both the current index and optional     |
|  data (like which month we are viewing).       |
\*----------------------------------------------*/
class NavState {
  final int currentIndex;
  final dynamic extraData;

  const NavState({required this.currentIndex, this.extraData});
}

class NavCubit extends Cubit<NavState> {
  /*----------------------------------------------*\
  |  Starts at index 0 (Dashboard)                 |
  \*----------------------------------------------*/
  NavCubit() : super(const NavState(currentIndex: 0));

  /*----------------------------------------------*\
  |  Change pages and optionally pass data         |
  \*----------------------------------------------*/
  void changeView(int newIndex, {dynamic extraData}) {
    emit(NavState(currentIndex: newIndex, extraData: extraData));
  }
}
