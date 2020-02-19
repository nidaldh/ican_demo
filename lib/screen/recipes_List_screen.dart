import 'package:demo_ican/data_layer/model/recipes.dart';
import 'package:demo_ican/ui_layer/web/web_controler.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipesList extends StatelessWidget {
  final List<Recipe> _master = Recipe.master;
  final List<Recipe> _pastry = Recipe.pastry;
  final List<Recipe> _soups = Recipe.soups;
  final List<Recipe> _salad = Recipe.salad;
  final List<Recipe> _juices = Recipe.juices;
///i have to build a card view list widget instead of all this Junk
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).tr("Healthy_recipes"),
              style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20)),
          backgroundColor: Colors.deepPurple,
        ),
        body: ListView(
          children: <Widget>[
            Card(
              color: Colors.purple[100],
              child: ListTile(
                title: Center(
                    child: Text("طبخات رئيسية",
                        style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20))),
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
                    title: Center(child: Text(_master[index].name,style: GoogleFonts.cairo(
                        fontWeight: FontWeight.w700, fontSize: 14))),
                    onTap: () => _handleURLButtonPress(
                        context, _master[index].url, _master[index].name),
                  ),
                );
              },
            ),
            Card(
              color: Colors.purple[100],
              child: ListTile(
                title: Center(
                    child: Text("معجنات",
                        style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20))),
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
                    title: Center(
                        child: Text(_pastry[index].name,
                            style: GoogleFonts.cairo(
                                fontWeight: FontWeight.w700, fontSize: 14))),
                    onTap: () => _handleURLButtonPress(
                        context, _pastry[index].url, _pastry[index].name),
                  ),
                );
              },
            ),
            Card(
              color: Colors.purple[100],
              child: ListTile(
                title: Center(
                    child: Text("شوربات",
                        style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20))),
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
                    title: Center(child: Text(_soups[index].name,style: GoogleFonts.cairo(
                        fontWeight: FontWeight.w700, fontSize: 14))),
                    onTap: () => _handleURLButtonPress(
                        context, _soups[index].url, _soups[index].name),
                  ),
                );
              },
            ),
            Card(
              color: Colors.purple[100],
              child: ListTile(
                title: Center(
                    child: Text("سلطات",
                        style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20))),
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
                    title: Center(child: Text(_salad[index].name,style: GoogleFonts.cairo(
                        fontWeight: FontWeight.w700, fontSize: 14))),
                    onTap: () => _handleURLButtonPress(
                        context, _salad[index].url, _salad[index].name),
                  ),
                );
              },
            ),
            Card(
              color: Colors.purple[100],
              child: ListTile(
                title: Center(
                    child: Text("عصائر و حلوبات",
                        style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20))),
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
                    title: Center(child: Text(_juices[index].name,style: GoogleFonts.cairo(
                        fontWeight: FontWeight.w700, fontSize: 14))),
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
