import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/navigation/nav_cubit.dart';

/*----------------------------------------------*\
|  The hamburger menu holding pages 5 through    |
|  10.                                           |
\*----------------------------------------------*/
class CoreDrawer extends StatelessWidget {
  const CoreDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).primaryColor))),
            child: Text('SYSTEM MENU', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 24)),
          ),
          _drawerItem(context, 'Audio Engine', 4, Icons.speaker),
          _drawerItem(context, 'Launchpad', 5, Icons.rocket_launch),
          _drawerItem(context, 'Motivation', 6, Icons.format_quote),
          _drawerItem(context, 'Data Ops', 7, Icons.save),
          _drawerItem(context, 'Settings', 8, Icons.settings),
        ],
      ),
    );
  }

  /*----------------------------------------------*\
  |  A helper method to avoid copying and pasting  |
  |  the ListTile code 5 times.                    |
  \*----------------------------------------------*/
  Widget _drawerItem(BuildContext context, String title, int targetIndex, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title),
      onTap: () {
        context.read<NavCubit>().changeView(targetIndex);
        /*----------------------------------------------*\
        |  Force the drawer to slide closed immediately  |
        |  after a selection is made.                    |
        \*----------------------------------------------*/
        Navigator.pop(context);
      },
    );
  }
}