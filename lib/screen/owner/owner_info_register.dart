import 'dart:io';

import 'package:christian_picker_image/christian_picker_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:rent_app/geolocator_api/geolocator_provider.dart';
import 'package:rent_app/screen/owner/map_renderer.dart';
import 'package:rent_app/style.dart';

class OwnerInfoRegisterScreen extends StatefulWidget {
  // Store user collection data for logged in user
  final Map<String, dynamic> userData;

  const OwnerInfoRegisterScreen({Key key, this.userData}) : super(key: key);

  @override
  _OwnerInfoRegisterScreenState createState() =>
      _OwnerInfoRegisterScreenState();
}

class _OwnerInfoRegisterScreenState extends State<OwnerInfoRegisterScreen> {
  bool imageUploaded = false;
  List<File> images;
  GeolocatorProvider geolocatorProvider = new GeolocatorProvider();
  Map<String, dynamic> locationData ;

  // Store current position of user during registration
  Position currentPosition;

  void takeImage(BuildContext context) async {
    images = await ChristianPickerImage.pickImages(maxImages: 1);
    setState(() {
      images.length != 0 ? imageUploaded = true : imageUploaded = false;
    });
    Navigator.of(context).pop();
  }

  Future _pickImage(BuildContext context) async {
    showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          takeImage(context);
          return Center();
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }

  getLocation()async{
    var locationInfo = await geolocatorProvider.getCurrentPositionPlacemark();
    setState(() {
      locationData = locationInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: new Row(
                children: <Widget>[
                  Expanded(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: "Welcome,",
                                style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "RobotoSlab",
                                    color: Colors.indigo)),
                            TextSpan(
                                text: " ${widget.userData["firstname"]}",
                                style: TextStyle(
                                    fontSize: 26,
                                    fontFamily: "RobotoSlab",
                                    color: Colors.indigo))
                          ]),
                        ),
                      ],
                    ),
                  )
                ],
              )),
          preferredSize: Size.fromHeight(70)),
      body: PageView(
        children: <Widget>[
          uploadProfilePictureWidget(),
          new Text("Add photos of home")
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async{

      }, child: new Icon(Icons.location_on),),
    );
  }

  Widget uploadProfilePictureWidget() {

    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text("Upload profile picture",
              style: AppTextStyle().cardHeadingPrimaryStyle),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                _pickImage(context);
              },
              child: imageUploaded
                  ? new Container(
                      height: size.height * 0.25,
                      width: size.width * 0.33,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: FittedBox(
                            fit: BoxFit.cover, child: Image.file(images[0])),
                      ),
                    )
                  : new Container(
                      height: size.height * 0.25,
                      width: size.width * 0.33,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Icon(
                            Icons.photo_camera,
                            color: Colors.white,
                          ),
                          new Text(
                            "Upload picture",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(20)),
                    ),
            ),
          ),
          new Text("Your current location",
              style: AppTextStyle().cardHeadingPrimaryStyle),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: new Container(
                child: Column(
                  children: <Widget>[
                   new Text(locationData.toString()),
                    new Text(locationData["isoCountryCode"]),
                    new Text(locationData["subLocality"]),
                    new Text(locationData["locality"]),
                    new Text(locationData["position"]["latitude"].toString()),
                    new Text(locationData["position"]["longitude"].toString()),
                  ],
                ),

                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
