import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/hourly_forecast_item.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String,dynamic>> weather;
  final city='Allahabad,IN';
  // double temp=0;
  // bool isLoading=false;
  Future<Map<String,dynamic>> getCurrentWeather() async{
     
      try{
        // setState(() {
        //   isLoading=true;
        // });
        final res=await http.get(
        //await pauses this function until the HTTP request finishes.
        Uri.parse(
          //url is subtype of uri(uniform resource idenficator)
          'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$myApikey&units=metric'
          ),
        );
        final data=jsonDecode(res.body);

        if(data['cod']!='200'){
          throw data['message'];
        }
        return data;
        //setState(() {
        
        //   isLoading=false;
        // });
        
        
      }
      catch(e){
        throw e.toString();
      }
  }
  @override
  void initState() {
    super.initState();
    weather=getCurrentWeather();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text(
            'Weather App',
            style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),
          ),
          centerTitle: true,
          actions:[
            IconButton(
              onPressed: (){
                setState(() {
                  weather=getCurrentWeather();
                });
              },
              icon: Icon(Icons.refresh),

             
              ),
          ],
        ) ,
        body:FutureBuilder(
          future: weather,
          builder:(context, snapshot) {
            
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: const CircularProgressIndicator.adaptive()
                );
            }
            if(snapshot.hasError){
              return Center(
                child: Text(snapshot.error.toString())
                );
            }

            final data=snapshot.data!;
          
            final weatherData= data['list'][0];
            final currentTemp=weatherData['main']['temp'];
            final currentSky=weatherData['weather'][0]['main'];
            final double currentHumidity=weatherData['main']['humidity'].toDouble();
            final double currentPressure=weatherData['main']['pressure'].toDouble();
            final double windSpeed=weatherData['wind']['speed'].toDouble();

            return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
            
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      ),
                    child:ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                        child:  Padding(
                          padding:const  EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$currentTemp°',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold
                                  ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Icon(
                                getIcon(currentSky),
                                size: 64,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                currentSky,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Weather Forecast',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
          
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //    children: [
                //     for(int i=1;i<=5;++i)
                //     HourlyForecastItem(
                //       icon:getIcon(data['list'][i]['weather'][0]['main']),
                //       labelTime: data['list'][i]['dt'].toString(),
                //       labelTemperature: data['list'][i]['main']['temp'].toString(),
                //       ), 
                    
                //    ],
                //   ),
                // ),
                
                SizedBox(
                  height: 123,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:5,
                    itemBuilder:(context,index){
                      final time = DateTime.parse(
                            data['list'][index + 1]['dt_txt'],
                      );

                      return HourlyForecastItem(
                        icon:getIcon(data['list'][index+1]['weather'][0]['main']),
                        labelTime: DateFormat.Hm().format(time),
                        labelTemperature: data['list'][index+1]['main']['temp'].toString(),
                        );
                    } ,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Additional Information',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                      AdditionalInfoItem(icon: Icons.water_drop,label: 'Humidity',val:currentHumidity),
                      AdditionalInfoItem(icon: Icons.air,label: 'Wind Speed',val:windSpeed),
                      AdditionalInfoItem(icon: Icons.beach_access,label: 'Pressure',val:currentPressure),
                  ],
                )
              ],
            ),
          );
          },
        ),
      );
  }
}

IconData getIcon(String currentSky) {
  switch (currentSky) {
    case 'Rain':
      return Icons.thunderstorm;
    case 'Clouds':
      return Icons.cloud;
    case 'Clear':
      return Icons.wb_sunny; 
    case 'Snow':
      return Icons.ac_unit;  
    case 'Thunderstorm':
      return Icons.thunderstorm; 
      case 'Mist':
    case 'Fog':
    case 'Haze':
      return Icons.foggy;          

    default:
      return Icons.cloud_queue; 
  }
}

