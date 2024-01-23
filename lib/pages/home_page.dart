import 'package:flutter/material.dart';
import 'package:meteo/models/device_info.dart';
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
    print(DeviceInfo.locationData);
    print(DeviceInfo.ville);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Météo"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.blue,
          child: Column(
            children: [
              DrawerHeader(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Villes", style: TextStyle(fontSize:  30, color: Colors.white),),
                      ElevatedButton(
                        onPressed: ajoutVille,
                        child: Text(
                          "Ajouter une ville",
                          style: TextStyle(color: Colors.blue),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white)),
                      ),
                    ],
                  )
              ),
              ListTile(
                onTap: null,
                title: Text("Position Inconnue", style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: villes.length,
                      itemBuilder: (BuildContext context, int index) {
                        String ville = villes[index];
                        return ListTile(
                          onTap: null,
                          title: Text(ville, style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
                          trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.white,),
                              onPressed: (){
                                deleteVille(ville);
                              }
                          ),

                        );
                      })),
            ],
          ),
        ),
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
    print(villes);
    await preferences.setStringList("villes", villes);
    getVilles();
  }

  Future<void> ajoutVille() {
    String? villeSaisie;

    return showDialog(
        context: context,
        builder: (BuildContext contextDialog) {
          return SimpleDialog(
            contentPadding: EdgeInsets.all(20),
            title: Text("Ajoutez une ville"),
            children: [
              TextField(
                decoration: InputDecoration(
                    labelText: "ville", hintText: "saisir ville"),
                onChanged: (String value) {
                  villeSaisie = value;
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    if(villeSaisie != null){
                      addVille(villeSaisie!);
                      Navigator.pop(contextDialog);
                    }
                  },
                  child: Text("Valider")),
            ],
          );
        });
  }

}
