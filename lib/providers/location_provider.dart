
import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';
import 'package:safezone_frontend/utils/location_util.dart';

class LocationProvider extends ChangeNotifier
{
  final LocationUtil _locationUtil;
  LocationTuple? _locationTuple;
  LocationProvider(this._locationUtil);

  Future<void> initLocationUtil() async
  {
    _locationUtil.initLocationObject();
    _locationTuple = await _locationUtil.getLocation();
    notifyListeners();
  }

  Stream<LocationData> getLocationStream()
  {
    return _locationTuple!.location.onLocationChanged;
  }

}