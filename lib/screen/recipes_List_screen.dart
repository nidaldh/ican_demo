import 'package:demo_ican/data_layer/model/lecture.dart';
import 'package:demo_ican/data_layer/model/recipes.dart';
import 'package:demo_ican/ui_layer/web/web_controler.dart';
import 'package:flutter/material.dart';

class RecipesList extends StatelessWidget {
  final List<Recipe> _master = Recipe.master;
  final List<Recipe> _pastry = Recipe.pastry;
  final List<Recipe> _soups = Recipe.soups;
  final List<Recipe> _salad = Recipe.salad;
  final List<Recipe> _juices = Recipe.juices;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Web View"),
          backgroundColor: Colors.deepPurple,
        ),
        body: ListView(
          children: <Widget>[
            Card(
              color: Colors.purple[100],
              child: ListTile(
                title: Center(child: Text("طبخات رئيسية")),
              ),
            ),
            ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: _master.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Center(child: Text(_master[index].name)),
                    onTap: () => _handleURLButtonPress(
                        context, _master[index].url, _master[index].name),
                  ),
                );
              },
            ),
            Card(
              color: Colors.purple[100],
              child: ListTile(
                title: Center(child: Text("معجنات")),
              ),
            ),
            ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: _pastry.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Center(child: Text(_pastry[index].name)),
                    onTap: () => _handleURLButtonPress(
                        context, _pastry[index].url, _pastry[index].name),
                  ),
                );
              },
            ),
            Card(
              color: Colors.purple[100],
              child: ListTile(
                title: Center(child: Text("شوربات")),
              ),
            ),
            ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: _soups.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Center(child: Text(_soups[index].name)),
                    onTap: () => _handleURLButtonPress(
                        context, _soups[index].url, _soups[index].name),
                  ),
                );
              },
            ),
            Card(
              color: Colors.purple[100],
              child: ListTile(
                title: Center(child: Text("سلطات")),
              ),
            ),
            ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: _salad.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Center(child: Text(_salad[index].name)),
                    onTap: () => _handleURLButtonPress(
                        context, _salad[index].url, _salad[index].name),
                  ),
                );
              },
            ),
            Card(
              color: Colors.purple[100],
              child: ListTile(
                title: Center(child: Text("عصائر و حلوبات")),
              ),
            ),
            ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: _juices.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Center(child: Text(_juices[index].name)),
                    onTap: () => _handleURLButtonPress(
                        context, _juices[index].url, _juices[index].name),
                  ),
                );
              },
            ),

          ],
        ));
  }

  void _handleURLButtonPress(BuildContext context, String url, String name) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewContainer(url, title: name)));
  }
}
