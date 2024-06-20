import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:live_location/Global_class.dart';

class MyLocation extends StatefulWidget {
  const MyLocation({super.key});

  @override
  State<MyLocation> createState() => _MyLocationState();
}

class _MyLocationState extends State<MyLocation> {

  final Color myColor = Color.fromRGBO(128,178,247, 1);

  String coordinates="No Location found";
  String address='No Address found';
  bool scanning=false;



  checkPermission()async{

    bool serviceEnabled;
    LocationPermission permission;


    permission=await Geolocator.checkPermission();

    print(permission);

    if (permission==LocationPermission.denied){

      permission=await Geolocator.requestPermission();

      if (permission==LocationPermission.denied){
        Global_method.show_toast(msg: 'Request Denied !', context: context);
        return ;
      }

    }

    if(permission==LocationPermission.deniedForever){
      Global_method.show_toast(msg: 'Denied Forever !', context: context);
      return ;
    }

    serviceEnabled=await Geolocator.isLocationServiceEnabled();

    print(serviceEnabled);

    if (!serviceEnabled){
      await Geolocator.openLocationSettings();
      return ;
    }





    getLocation();

  }

  getLocation()async{

    setState(() {scanning=true;});

    try{

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      coordinates='Latitude : ${position.latitude} \nLongitude : ${position.longitude}';

      List<Placemark> result  = await placemarkFromCoordinates(position.latitude, position.longitude);

      if (result.isNotEmpty){
        address='${result[0].street},${result[3].name}, ${result[4].locality} ${result[0].postalCode}, ${result[4].administrativeArea},${result[0].country}';

        print("street :- ${result[0].street}");
        print("name :- ${result[3].name}");
        print("locality :- ${result[4].locality}");
        print("postal code :- ${result[0].postalCode}");
        print("Addministrative :- ${result[4].administrativeArea}");
        print("country :- ${result[0].country}");
        print("result :- ${result.length}");
      }


    }catch(e){

      Global_method.show_toast(msg: "${e.toString()}", context: context);
    }

    setState(() {scanning=false;});
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPermission();

  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("Find Live Location"),
        titleTextStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 19),
        backgroundColor: Color(0xFF002147),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
          Image.asset('assets/location.gif',color:Color(0xFF002147)),

          SizedBox(height: 20,),
          Text('Current Location',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.green.shade700),),
          SizedBox(height: 20,),

          scanning?
          SpinKitThreeBounce(color: myColor,size: 20,):
          Text('${coordinates}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),

          SizedBox(height: 20,),
          Text('Current Address',style: TextStyle(fontSize: 19,fontWeight: FontWeight.w900,color: Colors.green.shade700),),
          SizedBox(height: 20,),

          scanning?
          SpinKitThreeBounce(color: myColor,size: 20,):
          Text('${address}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black,),textAlign: TextAlign.center,),
          SizedBox(height: 50,),
          Center(
            child: ElevatedButton.icon(
              onPressed: (){checkPermission();},
              icon: Icon(Icons.location_pin,color: Colors.white,),
              label: Text('Current Location',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF002147),),
            ),
          ),

          Spacer(),
        ],
      ),
    );
  }
}