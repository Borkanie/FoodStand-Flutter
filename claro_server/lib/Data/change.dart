import 'package:claro_server/Data/food.dart';
import 'package:claro_server/Data/container.dart';
import 'package:claro_server/Data/location.dart';

enum ChangeTypes{
  weigthIncrease,
  weigthDecrease,
  error,
  changeFood,
}

/// A change read by a sensor for a given [Location]
/// The change can mean [Food] was taken or added to a [Container].
/// The [ChangeTypes] can also signal that an error ahs ocurred and the sensor is no longer available.
class Change {
  ChangeTypes type;
  Location location;
  int? _valueChange;
  int get valueChange{
    if(_valueChange == null){
      return 0;
    }
    return _valueChange!;
  }
  Change(this.type, this.location);
}