import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarEvent {
  final String id;
  final Timestamp startDate;
  CalendarEvent(this.id, this.startDate);
}