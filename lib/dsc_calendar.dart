import 'package:flutter/material.dart';
// import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sliver_tools/sliver_tools.dart';

class DscCalendar extends StatefulWidget {
  const DscCalendar(
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
  _DscCalendarState createState() => _DscCalendarState();
}

class _DscCalendarState extends State<DscCalendar> {
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
          var day = DateTime(
              widget.beginDate.year, widget.beginDate.month + index, 1);
          var actualDays =
              DateTime(day.year, day.month + 1, day.day).difference(day).inDays;
          var beginWeekDayIndex = day.weekday - 1;
          var endDateOffsetToSunDay = 7 -
              DateTime(day.year, day.month + 1, day.day)
                  .add(Duration(days: -1))
                  .weekday;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                color: Colors.grey[200],
                height: 30,
                width: 999,
                child: Text(
                  '   ${day.year}年${day.month}月',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                // height: 300,
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                  ),
                  itemCount: endDateOffsetToSunDay + beginWeekDayIndex > 7 &&
                          DateTime(day.year, day.month + 1, day.day).weekday !=
                              1
                      ? 42
                      : 35,
                  itemBuilder: (BuildContext context, int index) {
                    if (index < beginWeekDayIndex) {
                      return SizedBox();
                    }
                    var daysOffset = index - beginWeekDayIndex;
                    if (daysOffset >= actualDays) {
                      return SizedBox();
                    }
                    var dayI = day.add(Duration(days: daysOffset));

                    var disabled = dayI.isAfter(widget.endDate) ||
                        dayI.isBefore(widget.beginDate);
                    var isSameDate = dayI.year == daySelected?.year &&
                        dayI.month == daySelected?.month &&
                        dayI.day == daySelected?.day;
                    return IconButton(
                      onPressed: disabled
                          ? null
                          : () {
                              widget.onDateSelected(dayI);
                              setState(() {
                                daySelected = dayI;
                              });
                            },
                      icon: Column(
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
                                            ? Colors.blue
                                            : [6, 7].contains(dayI.weekday)
                                                ? Colors.red
                                                : null),
                          ),
                          widget.bottomLabelBuilder?.call(dayI) ?? SizedBox()
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }), childCount: (2099 - widget.beginDate.year) * 12))
      ],
    );
  }
}
