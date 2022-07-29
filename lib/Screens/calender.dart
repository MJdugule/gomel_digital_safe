import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:websocket/Screens/wid/allpay.dart';

class DateView extends StatefulWidget {
  const DateView({Key? key}) : super(key: key);

  @override
  _DateViewState createState() => _DateViewState();
}

class _DateViewState extends State<DateView> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Center(
              child: TableCalendar(
            firstDay: DateTime.utc(1867, 10, 16),
            lastDay: DateTime.utc(2050, 3, 14),
            focusedDay: DateTime.now(),
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            startingDayOfWeek: StartingDayOfWeek.sunday,
            daysOfWeekVisible: true,
          )),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Payments',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 19),
                    ),
                  ],
                ),
                Container(
                    //height: MediaQuery.of(context).size.height,
                    child: AllPayment()),
              ],
            ),
          )
        ],
      ),
    );
  }
}
