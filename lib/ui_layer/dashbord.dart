import 'package:demo_ican/screen/video_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class DashBord extends StatelessWidget {
  BuildContext context2;
  @override
  Widget build(BuildContext context) {
    context2 = context;
    return StaggeredGridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: <Widget>[
        MyItem(Icons.done, "done", 0xffed622b, 1),
        MyItem(Icons.backspace, "back", 0xffed622b, 2),
        MyItem(Icons.insert_drive_file, "insert", 0xffed622b, 3),
      ],
      staggeredTiles: [
        StaggeredTile.extent(2, 60),
        StaggeredTile.extent(1, 60),
        StaggeredTile.extent(1, 60),
      ],
    );
  }

  Material MyItem(IconData icon, String string, int color, int index) {
    return Material(
        child: InkWell(
            child: Card(
                color: Colors.amber,
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(icon,color: Colors.purple,),
                SizedBox(width: 10,),
                Text(string),
              ],
            )),
            onTap: () {
              _onPressed(index);
            }));
  }

  void _onPressed(int position) {
    if (position == 1) {
      Navigator.of(context2).push(
        MaterialPageRoute(builder: (context) {
          return VideoList();
        }),
      );
    }
//    else if (position == 0) {
//      Navigator.of(context2).pushNamed(Uber.uberCan);
//    } else if (position == 2) {
//      Navigator.of(context2).pushNamed(FourMenu.fourthPage);
//    } else if (position == 3) {
//      Navigator.of(context2).pushNamed(LoginPage.navNewMember);
//    }

  }
}
