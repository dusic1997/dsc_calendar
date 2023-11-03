import 'dart:math';

import 'package:flutter/material.dart';
// import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sliver_tools/sliver_tools.dart';

class DscCalendarV2 extends StatefulWidget {
  const DscCalendarV2(
      {super.key,
      required this.beginDate,
      required this.endDate,
      this.bottomLabelBuilder,
      required this.onDateSelected,
      this.daySelected,
      this.daySelectedStyle});
  final DateTime beginDate;
  final DateTime endDate;
  final Widget Function(DateTime)? bottomLabelBuilder;
  final Function(DateTime) onDateSelected;
  final DateTime? daySelected;
  final TextStyle? daySelectedStyle;
  @override
  _DscCalendarV2State createState() => _DscCalendarV2State();
}

class _DscCalendarV2State extends State<DscCalendarV2> {
  List<DateTime> monthFirstDays = [];
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 200)).then((value) {
      // if (widget.daySelected != null) {
      //   autoScrollController.jumpTo(
      //     DateTime(widget.daySelected!.year, widget.daySelected!.month, 1)
      //             .difference(DateTime(1997, 1, 1))
      //             .inDays /
      //         30 *
      //         300,
      //   );
      // }
    });
  }

  late DateTime? daySelected = widget.daySelected;
  var autoScrollController = ScrollController();
  @override
  void dispose() {
    super.dispose();
    autoScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: autoScrollController,
      slivers: [
        SliverPinnedHeader(
            child: Material(
          color: Colors.white,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                  child: Text(
                '选择日期',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              )),
              Align(alignment: Alignment.centerRight, child: CloseButton())
            ],
          ),
        )),
        SliverPinnedHeader(
            child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, childAspectRatio: 1.5),
          itemCount: 7,
          itemBuilder: ((context, index) => Container(
              color: Colors.white,
              child: Center(
                  child:
                      Text('周${['一', '二', '三', '四', '五', '六', '日'][index]}')))),
        )),
        SliverList(
          delegate: SliverChildBuilderDelegate(((context, index) {
            var day1 =
                DateTime(widget.beginDate.year, widget.beginDate.month, 1);
            var day = day1.add(Duration(days: index * 7));
            var daysInWeek = List.generate(7,
                (index) => day.add(Duration(days: -(day.weekday - 1) + index)));
            for (var i = 0; i < 7; i++) {
              if (daysInWeek[i].day == 1 && i > 0) {
                return Column(
                  children: [
                    if (daysInWeek[0].isAfter(day1))
                      Row(
                        children: [
                          ...List.generate(
                              7,
                              (index) => Expanded(
                                  child: index < i
                                      ? _buildDayButton(
                                          daysInWeek[index], context)
                                      : SizedBox())),
                        ],
                      ),
                    _buildMonthName(daysInWeek, i),
                    Row(
                      children: [
                        ...List.generate(
                            7,
                            (index) => Expanded(
                                child: index < i
                                    ? SizedBox()
                                    : _buildDayButton(
                                        daysInWeek[index], context)))
                      ],
                    ),
                  ],
                );
              }
            }
            return Column(
              children: [
                if (daysInWeek[0].day == 1) _buildMonthName(daysInWeek, 0),
                Row(
                  children: [
                    ...daysInWeek.map(
                        (e) => Expanded(child: _buildDayButton(e, context)))
                  ],
                ),
              ],
            );
          }),
              // childCount:
              //     (max(1, widget.endDate.year - widget.beginDate.year)) * 12,
              addAutomaticKeepAlives: true),
        )
      ],
    );
  }

  IconButton _buildDayButton(DateTime dayI, BuildContext context) {
    var disabled =
        dayI.isAfter(widget.endDate) || dayI.isBefore(widget.beginDate);
    var isSameDate = dayI.year == daySelected?.year &&
        dayI.month == daySelected?.month &&
        dayI.day == daySelected?.day;
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: disabled
          ? null
          : () {
              widget.onDateSelected(dayI);
              setState(() {
                daySelected = dayI;
              });
            },
      icon: AspectRatio(
        aspectRatio: 1,
        child: Container(
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
              border: Border.all(
                  color: isSameDate
                      ? Theme.of(context).primaryColor
                      : Colors.transparent),
              borderRadius: BorderRadius.circular(9999)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${dayI.day}',
                style: isSameDate && widget.daySelectedStyle != null
                    ? widget.daySelectedStyle
                    : TextStyle(
                        fontSize: isSameDate ? 17 : null,
                        fontWeight: FontWeight.bold,
                        color: disabled
                            ? Colors.grey
                            : isSameDate
                                ? Theme.of(context).primaryColor
                                : [6, 7].contains(dayI.weekday)
                                    ? Colors.red
                                    : null),
              ),
              widget.bottomLabelBuilder?.call(dayI) ?? SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  Container _buildMonthName(List<DateTime> daysInWeek, int i) {
    return Container(
      alignment: Alignment.centerLeft,
      color: Colors.grey[200],
      height: 30,
      width: 999,
      child: Text(
        '   ${daysInWeek[i].year}年${daysInWeek[i].month}月',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Center _buildDay(DateTime e) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text('${e.day}'),
    ));
  }
}
