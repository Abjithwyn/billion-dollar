// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:developer';

import 'package:billion_book/screens/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class TableEventsExample extends StatefulWidget {
  const TableEventsExample({super.key});

  @override
  State<TableEventsExample> createState() => _TableEventsExampleState();
}

class _TableEventsExampleState extends State<TableEventsExample> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime selectedUpperDate = DateTime(DateTime.now().year,
      DateTime.now().month, DateTime.now().day, 23, 59, 59);
  DateTime selectedLowerDate = DateTime(DateTime.now().year,
      DateTime.now().month, DateTime.now().day, 0, 0, 0, 0);
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  List<dynamic> eventlist = [];

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    // FirebaseFirestore.instance
    //     .collection('test')
    //     .doc('dd')
    //     .set({'upper': selectedUpperDate, 'lower': selectedLowerDate});
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    log(day.toString());
    return kEvents[day] ?? [];
  }

  // List<Event> _getEventsForRange(DateTime start, DateTime end) {
  //   // Implementation example
  //   final days = daysInRange(start, end);

  //   return [
  //     for (final d in days) ..._getEventsForDay(d),
  //   ];
  // }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }

    log('called');
  }

  // void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
  //   setState(() {
  //     _selectedDay = null;
  //     _focusedDay = focusedDay;
  //     _rangeStart = start;
  //     _rangeEnd = end;
  //     _rangeSelectionMode = RangeSelectionMode.toggledOn;
  //   });

  //   // `start` or `end` could be null
  //   if (start != null && end != null) {
  //     _selectedEvents.value = _getEventsForRange(start, end);
  //   } else if (start != null) {
  //     _selectedEvents.value = _getEventsForDay(start);
  //   } else if (end != null) {
  //     _selectedEvents.value = _getEventsForDay(end);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Billion Book'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2023),
            lastDay: DateTime.now(),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            // rangeStartDay: _rangeStart,
            // rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            // eventLoader: _getEventsForDay,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            calendarStyle: const CalendarStyle(
              outsideDaysVisible: false,
            ),
            onDaySelected: _dupeonDaySelected,
            // onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: FirestoreQueryBuilder<Map<String, dynamic>>(
              query: FirebaseFirestore.instance
                  .collection('transaction')
                  .where('date', isGreaterThanOrEqualTo: selectedLowerDate)
                  .where('date', isLessThanOrEqualTo: selectedUpperDate)
                  .orderBy('date'),
              builder: (context, snapshot, _) {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.docs.length,
                  itemBuilder: (context, index) {
                    if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                      snapshot.fetchMore();
                    }

                    final user = snapshot.docs[index].data();
                    DateTime dday = user['date'].toDate();
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        // onTap: () => print('${value[index]}'),
                        title: Text(
                          " Amount: ${user['amount']} ${user['type']}ed",
                          style: TextStyle(
                              fontSize: 25,
                              color: user['type'] == 'credit'
                                  ? Colors.teal[500]
                                  : Colors.red[500]),
                        ),
                      ),
                    );

                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Container(
                    //     padding: const EdgeInsets.all(8),
                    //     decoration: BoxDecoration(
                    // color: user['type'] == 'credit'
                    //     ? Colors.teal[100]
                    //     : Colors.red[200],
                    //         borderRadius: BorderRadius.circular(10)),
                    //     child: Text(
                    //       " Amount: ${user['amount']} ${user['type']}ed",
                    //       style: const TextStyle(fontSize: 25),
                    //     ),
                    //   ),
                    // );
                  },
                );
              },
            ),
            // child: ValueListenableBuilder<List<Event>>(
            //   valueListenable: _selectedEvents,
            //   builder: (context, value, _) {
            //     return ListView.builder(
            //       itemCount: value.length,
            //       itemBuilder: (context, index) {
            //         return Container(
            //           margin: const EdgeInsets.symmetric(
            //             horizontal: 12.0,
            //             vertical: 4.0,
            //           ),
            //           decoration: BoxDecoration(
            //             border: Border.all(),
            //             borderRadius: BorderRadius.circular(12.0),
            //           ),
            //           child: ListTile(
            //             onTap: () => print('${value[index]}'),
            //             title: Text('${value[index]}'),
            //           ),
            //         );
            //       },
            //     );
            //   },
            // ),
          ),
        ],
      ),
    );
  }

  void _dupeonDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
        selectedUpperDate = DateTime(
            selectedDay.year, selectedDay.month, selectedDay.day, 23, 59, 59);
        selectedLowerDate = DateTime(
            selectedDay.year, selectedDay.month, selectedDay.day, 0, 0, 0, 0);
      });

      // _selectedEvents.value = _dupegetEventsForDay(selectedDay);
    }
  }

  // List<> _dupegetEventsForDay(DateTime day) {
  //   // Implementation example
  //   // log(kEvents[day].toString());
  //   // log(day.toString());
  //   getDocumentsFromCollection(day);
  //   return eventlist[day] ?? [];
  // }

  Future<List<dynamic>> getDocumentsFromCollection(DateTime day) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('transaction')
        .where('date', isGreaterThanOrEqualTo: DateTime(day.year, day.month, 1))
        .where('date', isLessThanOrEqualTo: DateTime(day.year, day.month, 25))
        .get();

    for (var document in querySnapshot.docs) {
      // Add the document data to the list
      eventlist.add(document.data());
    }
    log(eventlist.toString());
    return eventlist;
  }
}

class DupeEvent {
  final String title;
  final String description;

  DupeEvent(this.title, this.description);
}
