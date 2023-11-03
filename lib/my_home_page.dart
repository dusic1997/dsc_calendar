import 'dart:math';

import 'package:dsc_calendar/dsc_calendar.dart';
import 'package:dsc_calendar/dsc_calendar_v2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                    // enableDrag: false,
                    // bounce: false,
                    // // constraints: BoxConstraints(
                    // //     minHeight: MediaQuery.of(context).size.height * 0.2),
                    // clipBehavior: Clip.hardEdge,
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(15)),
                    context: context,
                    builder: ((context) => Material(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: DscCalendarV2(
                                daySelected: DateTime.now(),
                                bottomLabelBuilder: (date) => date.day % 7 == 0
                                    ? Text(
                                        '¥99.99',
                                        style: TextStyle(fontSize: 8),
                                      )
                                    : SizedBox(),
                                onDateSelected: (date) {
                                  print(date);
                                },
                                beginDate: DateTime(2023, 9, 20),
                                endDate: DateTime(2099, 1, 1)),
                          ),
                        )));
              },
              child: Text('show calendarv2')),
          ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                    // enableDrag: false,
                    // bounce: false,
                    // // constraints: BoxConstraints(
                    // //     minHeight: MediaQuery.of(context).size.height * 0.2),
                    // clipBehavior: Clip.hardEdge,
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(15)),
                    context: context,
                    builder: ((context) => Material(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: DscCalendar(
                                daySelected: DateTime.now(),
                                bottomLabelBuilder: (date) => date.day % 7 == 0
                                    ? Text(
                                        '¥99.99',
                                        style: TextStyle(fontSize: 8),
                                      )
                                    : SizedBox(),
                                onDateSelected: (date) {
                                  print(date);
                                },
                                beginDate: DateTime(2023, 9, 20),
                                endDate: DateTime(2099, 1, 1)),
                          ),
                        )));
              },
              child: Text('show calendar')),
        ],
      ),
    );
  }
}
