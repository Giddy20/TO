import 'dart:developer';

import 'package:app/models/calendar_event.dart';
import 'package:app/widgets/calendar_event_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../constants.dart';
import '../widgets/custom_app_bar.dart';

class MyCalendar extends StatefulWidget {
  const MyCalendar({Key? key}) : super(key: key);

  @override
  State<MyCalendar> createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  bool loading = false;
  List<CalendarEvent> myCalendarEvents = [];
  List<CalendarEvent> selectedEvents = [];

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final kToday = DateTime.now();
  final kFirstDay = DateTime(
      DateTime.now().year, DateTime.now().month - 3, DateTime.now().day);
  final kLastDay = DateTime(
      DateTime.now().year, DateTime.now().month + 3, DateTime.now().day);

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    getEvents();
  }

  void getEvents() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      List<CalendarEvent> myCalEvents = [];
      await FirebaseFirestore.instance
          .collection('adminEventUsers')
          .where('startDate', isGreaterThanOrEqualTo: kFirstDay)
          .where('startDate', isLessThanOrEqualTo: kLastDay)
          .where('userID', isEqualTo: user.uid)
          .get()
          .then((value) {
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in value.docs) {
          myCalEvents.add(
              CalendarEvent(doc.data()['eventID'], doc.data()['startDate']));
        }
        setState(() {
          myCalendarEvents = myCalEvents;
          loading = false;
        });
      }).catchError((onError) {
        log(onError);
      });
    }
  }

  void goBack() {
    Navigator.of(context).pop();
  }

  Widget getBackButton() {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: goBack,
      color: Colors.white,
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      List<CalendarEvent> events = myCalendarEvents
          .where((element) =>
              element.startDate.toDate().day == selectedDay.day &&
              element.startDate.toDate().month == selectedDay.month &&
              element.startDate.toDate().year == selectedDay.year)
          .toList();
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        selectedEvents = events;
      });
    }
  }

  List<CalendarEvent> _getEventsForDay(DateTime day) {
    List<CalendarEvent> events = myCalendarEvents
        .where((element) =>
            element.startDate.toDate().day == day.day &&
            element.startDate.toDate().month == day.month &&
            element.startDate.toDate().year == day.year)
        .toList();
    return events;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          child: CustomAppBar(getBackButton(), "Calendar", const []),
          preferredSize: Size(MediaQuery.of(context).size.width, appBarHeight),
        ),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  TableCalendar<CalendarEvent>(
                    firstDay: kFirstDay,
                    lastDay: kLastDay,
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    calendarFormat: CalendarFormat.month,
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Month'
                    },
                    rangeSelectionMode: RangeSelectionMode.disabled,
                    eventLoader: _getEventsForDay,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    calendarStyle: const CalendarStyle(
                      outsideDaysVisible: false,
                      selectedDecoration: BoxDecoration(
                          color: goldColor, shape: BoxShape.circle),
                    ),
                    onDaySelected: _onDaySelected,
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Events on ${_focusedDay.day} ${Constants.getMonthName(_focusedDay.month)} ${_focusedDay.year} (${Constants.getDayName(_focusedDay.weekday)})",
                        style: const TextStyle(
                          fontSize: 20,
                          color: goldColor,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: selectedEvents.isNotEmpty
                        ? ListView.builder(
                            itemCount: selectedEvents.length,
                            itemBuilder: (context, index) {
                              return CalendarEventCard(
                                  selectedEvents[index].id);
                            },
                          )
                        : const Center(
                            child: Text("No Events yet"),
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}
