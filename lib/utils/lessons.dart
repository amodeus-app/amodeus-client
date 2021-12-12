import 'package:amodeus_api/amodeus_api.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

const lessonDuration = Duration(hours: 1, minutes: 30);

final _breakColor = Colors.grey.withOpacity(0.2);
final _holidayColor = Colors.grey.withOpacity(0.3);
const _heldLessonOpacity = 0.4;

class LessonDataSource extends CalendarDataSource {
  LessonDataSource(BuiltList<TimetableElement> lessons) {
    appointments = List.from(lessons);
  }

  TimetableElement _appointmentAt(int index) => appointments![index];

  @override
  DateTime getStartTime(int index) {
    return _appointmentAt(index).start.toLocal();
  }

  @override
  DateTime getEndTime(int index) {
    return _appointmentAt(index).end.toLocal();
  }

  @override
  String getSubject(int index) {
    return _appointmentAt(index).lesson.subject.nameShort;
  }

  @override
  Color getColor(int index) {
    final Color color;
    switch (_appointmentAt(index).lesson.type) {
      case "SEMI":
        color = Colors.lightBlue;
        break;
      case "LECT":
        color = Colors.lightGreen;
        break;
      case "LAB":
        color = Colors.orangeAccent;
        break;
      case "CONS":
        color = Colors.deepPurpleAccent;
        break;
      default:
        switch (_appointmentAt(index).lesson.format) {
          case "PRETEST":
            color = Colors.pinkAccent;
            break;
          case "EXAMINATION":
            color = Colors.greenAccent;
            break;
          default:
            assert(_appointmentAt(index).lesson.type != "MID_CHECK");
            color = Colors.grey;
            break;
        }
    }

    if (getStartTime(index).isBefore(DateTime.now())) {
      return color.withOpacity(_heldLessonOpacity);
    }
    return color;
  }

  @override
  String? getLocation(int index) {
    return _appointmentAt(index).location?.full;
  }

  @override
  bool isAllDay(int index) => false;
}

final defaultNonWorkingDays = <TimeRegion>[
  TimeRegion(
    startTime: DateTime(1970, 1, 1),
    endTime: DateTime(1970, 1, 2),
    recurrenceRule: "FREQ=WEEKLY;INTERVAL=1;BYDAY=SUN",
    color: _holidayColor,
  ),
];

final defaultTimetableBreaks = <List<int>>[
  [8, 0, 8, 30],
  [10, 0, 10, 15],
  [11, 45, 12, 0],
  [13, 30, 14, 0],
  [15, 30, 15, 45],
  [17, 15, 17, 30],
  [19, 0, 19, 10],
  [20, 40, 20, 50],
]
    .map((e) => TimeRegion(
          startTime: DateTime(2020, 9, 1, e[0], e[1]),
          endTime: DateTime(2020, 9, 1, e[2], e[3]),
          recurrenceRule: "FREQ=DAILY;INTERVAL=1",
          color: _breakColor,
        ))
    .toList(growable: false);
