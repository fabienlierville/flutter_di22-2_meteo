import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> villes = [];

  @override
  void initState() {
    super.initState();
    getVilles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Météo"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            print(villes);
            addVille("Lille");
            print(villes);
          },
          child: Text("Ajout Ville"),
        ),
      ),
    );
  }

  void getVilles() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String>? liste = preferences.getStringList("villes");
    if(liste != null){
      setState(() {
        villes = liste;
      });
    }
  }

  void addVille(String ville) async{
    if(villes.contains(ville)){
      return;
    }
    villes.add(ville);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setStringList("villes", villes);
    getVilles();
  }

  void deleteVille(String ville) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    villes.remove(ville);
    await preferences.setStringList("villes", villes);
    getVilles();
  }

}
