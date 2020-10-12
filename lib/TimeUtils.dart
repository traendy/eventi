import 'package:sprintf/sprintf.dart';

formatTime(DateTime date) {
//  return date.hour.toString() + ":" + date.minute.toString();
  return sprintf("%02d:%02d", [date.hour,date.minute]);
}