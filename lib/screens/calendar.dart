import 'dart:developer';
import 'package:billion_book/common/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  int dynamic_index = 0;
  String monthString = '';
  bool shouldSetstate = false;
  final calendarQuery = FirebaseFirestore.instance
      .collection('calendar')
      .orderBy('date', descending: true);
  String caledarId = 'sample';
  int month = 0;
  int day = 0;
  int year = 0;
  void statesetting() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {});
      }
    });
  }

  String getMonthString(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  @override
  void initState() {
    super.initState();
    calendarQuery.limit(1).get().then((snapshot) {
      log(snapshot.docs.length.toString());
      if (snapshot.docs.isNotEmpty) {
        day = snapshot.docs.first.data()['date'].toDate().day;
        month = snapshot.docs.first.data()['date'].toDate().month;
        year = snapshot.docs.first.data()['date'].toDate().year;
        caledarId = snapshot.docs.first.id;
        log(caledarId);
        monthString = getMonthString(month);

        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      // appBar: AppBar(
      //   centerTitle: true,
      //   // systemOverlayStyle: const SystemUiOverlayStyle(
      //   //   statusBarColor: Colors.transparent,
      //   //   statusBarIconBrightness: Brightness.light,
      //   //   statusBarBrightness: Brightness.light,
      //   // ),
      //   title: const Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Text(
      //         'Calendar',
      //         style: TextStyle(
      //           fontFamily: 'lato',
      //           color: Colors.white,
      //           fontSize: 20,
      //         ),
      //       ),
      //     ],
      //   ),
      //   backgroundColor: Colors.transparent,
      //   automaticallyImplyLeading: true,
      //   elevation: 0,
      //   // leading: IconButton(
      //   //   color: const Color.fromARGB(255, 255, 255, 255),
      //   //   icon: const Icon(Icons.arrow_back),
      //   //   onPressed: () => Navigator.of(context).pop(),
      //   // ),
      // ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              // color: Colors.red,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Text(
                      monthString,
                      style: const TextStyle(
                        overflow: TextOverflow.clip,
                        fontSize: 25,
                        fontFamily: 'thin',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // const Gap(10),
                  SizedBox(
                    height: 90,
                    width: MediaQuery.of(context).size.width,
                    child: FirestoreQueryBuilder<Map<String, dynamic>>(
                      query: calendarQuery,
                      pageSize: 2,
                      builder: (context, snapshot, _) {
                        if (snapshot.hasData) {
                          final month = snapshot.docs[dynamic_index]
                              .data()['date']
                              .toDate()
                              .month;
                          monthString = getMonthString(month);
                        }
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.docs.length,
                          itemBuilder: (context, index) {
                            if (snapshot.hasMore &&
                                index + 1 == snapshot.docs.length) {
                              snapshot.fetchMore();
                            }
                            DateTime date =
                                snapshot.docs[index].data()['date'].toDate();
                            final wDay = date.weekday;
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 10),
                              child: SizedBox(
                                // height: MediaQuery.of(context).size.height * 0.05,
                                child: GestureDetector(
                                  onTap: () {
                                    log('message');
                                    setState(() {
                                      dynamic_index = index;
                                      monthString = getMonthString(date.month);
                                      caledarId = snapshot.docs[index].id;
                                      month = date.month;
                                      day = date.day;
                                      year = date.year;
                                    });
                                  },
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    decoration: BoxDecoration(
                                      border: dynamic_index == index
                                          ? null
                                          : Border.all(color: Colors.white),
                                      gradient: dynamic_index == index
                                          ? const LinearGradient(
                                              colors: [
                                                Color.fromARGB(
                                                    255, 255, 124, 209),
                                                Color.fromARGB(
                                                    255, 135, 255, 139)
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            )
                                          : null,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CustomWidgets().boldTextbox(
                                              getWeekdayString(wDay),
                                              16,
                                              Colors.white),
                                          CustomWidgets().boldTextbox(
                                              date.day.toString(),
                                              25,
                                              Colors.white),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: FirestoreListView<Map<String, dynamic>>(
                  physics: const BouncingScrollPhysics(),
                  query: FirebaseFirestore.instance
                      .collection('transaction')
                      .where('day', isEqualTo: day)
                      .where('month', isEqualTo: month)
                      .where('year', isEqualTo: year)
                      .orderBy('date', descending: true),
                  itemBuilder: (context, snapshot) {
                    // log(day.toString());
                    // log(month.toString());
                    // log(year.toString());
                    Map<String, dynamic> user = snapshot.data();
                    DateTime start = user['date'].toDate();
                    // DateTime end = user['date'].toDate();
                    String time =
                        '${start.hour == 0 ? 12 : start.hour > 12 ? start.hour - 12 : start.hour}:${start.minute.toString().padLeft(2, '0')} ${start.hour > 11 ? 'PM' : 'AM'}';
                    // String endTime =
                    //     '${end.hour == 0 ? 12 : end.hour > 12 ? end.hour - 12 : end.hour}:${end.minute.toString().padLeft(2, '0')} ${end.hour > 11 ? 'PM' : 'AM'}';
                    // log('----------------' + start.hour.toString());
                    return Padding(
                      padding:
                          const EdgeInsets.only(top: 0, left: 18, right: 18),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              // Row(
                              //   children: [
                              //     // CustomWidgets()
                              //     //     .boldTextbox(time, 15, Colors.black54),
                              //     SizedBox(
                              //       width:
                              //           MediaQuery.of(context).size.width * 0.7,
                              //       child: const Divider(
                              //         color: Colors.black38,
                              //         height: 1,
                              //         thickness: 1,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              const Gap(8),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: user['type'] == 'debit'
                                      ? Color.fromARGB(255, 255, 104, 104)
                                      : Color.fromARGB(255, 112, 255, 153),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.03,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.04,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: user['type'] ==
                                                            'debit'
                                                        ? const AssetImage(
                                                            "assets/images/time_white.png")
                                                        : const AssetImage(
                                                            "assets/images/time_black.png"),
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                              const Gap(10),
                                              CustomWidgets().normalTextbox(
                                                  time.toLowerCase(),
                                                  12,
                                                  user['type'] == 'debit'
                                                      ? const Color.fromARGB(
                                                          255, 255, 255, 255)
                                                      : const Color.fromARGB(
                                                          255, 0, 0, 0)),
                                            ],
                                          ),
                                          CustomWidgets().boldTextbox(
                                              snapshot.data()['note'],
                                              12,
                                              user['type'] == 'debit'
                                                  ? Color.fromARGB(
                                                      255, 255, 255, 255)
                                                  : Color.fromARGB(
                                                      255, 0, 0, 0)),
                                          const Gap(2),
                                        ],
                                      ),
                                      CustomWidgets().boldTextbox(
                                          user['type'] == 'debit'
                                              ? '-' + user['amount']
                                              : '+' + user['amount'],
                                          15,
                                          user['type'] == 'debit'
                                              ? Color.fromARGB(
                                                  255, 255, 255, 255)
                                              : Color.fromARGB(255, 0, 0, 0))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              // height: 100,
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 8),
                      child: CustomWidgets().boldTextbox(
                        monthString + ' : 2000',
                        18,
                        Color.fromARGB(255, 145, 255, 157),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 8),
                      child: CustomWidgets().boldTextbox(
                        monthString + ' : 1000',
                        18,
                        const Color.fromARGB(255, 255, 138, 138),
                      ),
                    ),
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.only(top: 8.0, left: 8),
                //       child: CustomWidgets().boldTextbox(
                //         'LM credit : ',
                //         18,
                //         Color.fromARGB(255, 145, 255, 157),
                //       ),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.only(top: 8.0, right: 8),
                //       child: CustomWidgets().boldTextbox(
                //         'LM debit : ',
                //         18,
                //         const Color.fromARGB(255, 255, 138, 138),
                //       ),
                //     ),
                //   ],
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 8),
                      child: CustomWidgets().boldTextbox(
                        'LM Bal : 500',
                        18,
                        Color.fromARGB(255, 145, 255, 157),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 8),
                      child: CustomWidgets().boldTextbox(
                        'Total Bal: 1500',
                        18,
                        Color.fromARGB(255, 145, 255, 157),
                      ),
                    ),
                  ],
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }

  String getWeekdayString(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }
}
