import 'package:flutter/material.dart';
import 'package:meteo/models/device_info.dart';
import 'package:meteo/models/weather.dart';
import 'package:meteo/my_flutter_app_icons.dart';
import 'package:meteo/services/geocoder_service.dart';
import 'package:meteo/services/weather_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> villes = [];
  Weather? weather;
  String? villeChoisie;

  @override
  void initState(){
    super.initState();
    getVilles();
    getMeteo(DeviceInfo.ville!);
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
                onTap: (){
                  getMeteo(DeviceInfo.ville!);
                  Navigator.pop(context);
                },
                title: Text(DeviceInfo.ville ?? "Position Inconnue", style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: villes.length,
                      itemBuilder: (BuildContext context, int index) {
                        String ville = villes[index];
                        return ListTile(
                          onTap: (){
                            getMeteo(ville);
                            Navigator.pop(context);
                          },
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
    body: (weather == null) ?
    Center(
        child: Text("PAs de météo dispo"),
      )
        :
    Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(weather!.backgroundPicture()),
              fit: BoxFit.cover)),
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(villeChoisie!, style: TextStyle(fontSize: 30, color: Colors.white),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("${weather?.main?.temp?.toStringAsFixed(1)} °C",style: TextStyle(fontSize: 40, color: Colors.white),),
              Image.asset(weather!.getIconeImage())
            ],
          ),
          Text(weather?.weather?[0].main ?? "", style: TextStyle(fontSize: 30, color: Colors.white),),
          Text(weather?.weather?[0].description ?? "", style: TextStyle(fontSize: 25, color: Colors.white),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Icon(MyFlutterApp.temperatire, color: Colors.white,),
                  Text(weather!.main?.pressure?.toInt().toString() ?? "", style: TextStyle(fontSize: 20, color: Colors.white),),
                ],
              ),
              Column(
                children: [
                  Icon(MyFlutterApp.droplet, color: Colors.white,),
                  Text(weather!.main?.humidity?.toInt().toString() ?? "", style: TextStyle(fontSize: 20, color: Colors.white),),
                ],
              ),
              Column(
                children: [
                  Icon(MyFlutterApp.arrow_upward, color: Colors.white),
                  Text(weather!.main?.tempMax?.toStringAsFixed(1) ?? "", style: TextStyle(fontSize: 20, color: Colors.white),),
                ],
              ),
              Column(
                children: [
                  Icon(MyFlutterApp.arrow_downward, color: Colors.white),
                  Text(weather!.main?.tempMin?.toStringAsFixed(1) ?? "", style: TextStyle(fontSize: 20, color: Colors.white),),
                ],
              ),
            ],
          )

        ],
      ),
    ),

    );
  }

  Future<void> getMeteo(String ville) async{
    GeocoderService geocoderService = GeocoderService();
    Map<String,double>? location = await geocoderService.getCoordinatesFromAddress(ville: ville);
    if(location !=null){
      WeatherService weatherService = WeatherService();
      Weather? w = await weatherService.getCurrentWeather(latitude: location["latitude"]!, longitude: location["longitude"]!);
      if(w != null){
        setState(() {
          weather = w;
          villeChoisie = ville;
        });
      }
    }
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
