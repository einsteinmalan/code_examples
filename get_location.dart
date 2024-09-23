import 'package:muslimconnect/core/my_pref.dart';
import 'package:muslimconnect/core/xcontroller.dart';
import 'package:flutter/material.dart';
//import 'package:geocoding/geocoding.dart' as geo;
import 'package:get/get.dart';
import 'package:location/location.dart';

class GetLocation {
  GetLocation._internal() {
    debugPrint("GetLocation._internal...");
    init();
  }

  static final GetLocation _instance = GetLocation._internal();
  static GetLocation get instance => _instance;

  final box = Get.find<MyPref>();

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;

  LocationData? _locationData;
  LocationData get locationData => _locationData!;

  String? _latitude;
  String get latitude => _latitude ?? "";

  String? _currentAddress;
  String get currentAddress => _currentAddress ?? "";

  String? _country;
  String get country => _country ?? "";

  String? _shortAddr;
  String get shortAddr => _shortAddr ?? "";

  init() async {
    debugPrint("init geolocation...");
    getLatitudeAddress();
    final Location location = Location();

    try {
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

     // _locationData = await location.getLocation();
      saveLatitude(locationData);
    } catch (e) {
      debugPrint("Error getLocation ${e.toString()}");
    }

    ///Remove this to make it continuously updating user position...but can add up to cost
   // Future.microtask(() => listenStreamPosition(location));
  }

  listenStreamPosition(final Location location) {
    debugPrint(" listenStreamPosition get latest latitude");

    location.onLocationChanged.listen((LocationData currentLocation) {

      saveLatitude(currentLocation);
    });
  }

  getLatitudeAddress() {
    try {
      String lat = box.pLatitude.val;
      if (lat != '') {
        _latitude = lat;
        debugPrint(latitude);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    try {
      String add = box.pLocation.val;
      if (add != '') {
        _currentAddress = add;
        debugPrint(_currentAddress);

        String firstAddress = getSplitCurrentAddress(2).trim();
        if (firstAddress == '') {
          firstAddress = getSplitCurrentAddress(1).trim();
        } else {
          firstAddress = "$firstAddress ${getSplitCurrentAddress(3).trim()}";
        }
        _shortAddr =
            "${firstAddress.trim()},${getSplitCurrentAddress(5).trim()}";
        debugPrint("getLatitudeAddress $_shortAddr");
      } else {
        if (latitude != '') {
          var split = latitude.split(",");
          getAddressFromLatitude(
              double.parse(split[0]), double.parse(split[1]));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  saveLatitude(final LocationData position) {
    _locationData = position;
    _latitude = "${position.latitude},${position.longitude}";

    debugPrint("saveLatitude: $latitude");

    box.pLatitude.val = latitude;
    getAddressFromLatitude(position.latitude!, position.longitude!);
  }

  getAddressFromLatitude(double getLatitude, double getLongitude) async {
    // if (_latitude != null && latitude != '') {
    //   List<geo.Placemark> placemarks =
    //       await geo.placemarkFromCoordinates(getLatitude, getLongitude);
    //   geo.Placemark place = placemarks[0];
    //   _currentAddress =
    //       "${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}, ${place.isoCountryCode}, ${place.postalCode}";
    //
    //   String locality = place.locality ?? '';
    //   if (locality.trim() == '') {
    //     locality = "${place.subLocality}";
    //   }
    //
    //   _country = "${place.isoCountryCode}";
    //   _shortAddr = "${locality.trim()} ${place.isoCountryCode}";
    //
    //   debugPrint(shortAddr);
    //   debugPrint(currentAddress);
    //
    //   box.pLocation.val = currentAddress;
    //   box.pCountry.val = country;
    //
    //   XController.to.asyncLatitude();
    // }
  }

  String getShortCurrentAddress() {
    var result = "";
    if (_currentAddress != null) {
      var split = _currentAddress!.split(",");
      result = "${split[1]} ${split[2]}";
      //return result;
    } else {
      String getAdd = box.pLocation.val;
      if (getAdd != '' && getAdd.isNotEmpty) {
        _currentAddress = getAdd;
        return getShortCurrentAddress();
      }
    }

    return result;
  }

  String getSplitCurrentAddress(index) {
    var result = "";

    try {
      if (_currentAddress != null) {
        var split = _currentAddress!.split(",");
        result = split[index]; // + " " + split[2];
      } else {
        String getAdd = box.pLocation.val;
        if (getAdd != '' && getAdd.isNotEmpty) {
          _currentAddress = getAdd;
          return getSplitCurrentAddress(index);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return result;
  }
}
